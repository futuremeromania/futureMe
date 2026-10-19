import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

/// Owns `users/{uid}/moduleProgress/{moduleId}` and its `answers`
/// subcollection. `moduleId` is `'module1'`..`'module5'`.
@lazySingleton
class ModuleProgressRepository {
  ModuleProgressRepository(this._firestore, this._functions);

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CollectionReference<Map<String, dynamic>> _moduleProgressCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('moduleProgress');

  DocumentReference<Map<String, dynamic>> _moduleDoc(String uid, String moduleId) =>
      _moduleProgressCollection(uid).doc(moduleId);

  Future<void> markStarted(String uid, String moduleId) {
    return _moduleDoc(uid, moduleId).set({
      'status': 'in_progress',
      'startedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> markCompleted(String uid, String moduleId) {
    return _moduleDoc(uid, moduleId).set({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
      // A finished module has nothing left to resume.
      'resume': FieldValue.delete(),
    }, SetOptions(merge: true));
  }

  /// Where the user left off inside a module: the [stage] (0 for modules
  /// without stages), the [index] of the next question to show within it
  /// (0 = the stage's introduction, the stage length = all answered), and
  /// the answers collected so far in that stage, keyed by item number as a
  /// string. The individual answers are also saved on their own under
  /// `answers`; this copy exists so a stage can be picked up again without
  /// re-reading and re-parsing every answer document.
  Future<void> saveResume(String uid, String moduleId, {required int stage, required int index, required Map<String, Object> answers}) {
    return _moduleDoc(uid, moduleId).set({
      'resume': {
        'stage': stage,
        'index': index,
        'answers': answers,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
  }

  /// The saved resume point of a module, or null when there is none (never
  /// started, finished, or reset for a retake).
  Future<Map<String, dynamic>?> fetchResume(String uid, String moduleId) async {
    final snapshot = await _moduleDoc(uid, moduleId).get();
    final data = snapshot.data();
    if (data == null || data['status'] == 'completed') return null;
    final resume = data['resume'];
    return resume is Map<String, dynamic> ? resume : null;
  }

  /// Returns how many of module1..module5 have `status: 'completed'`, used
  /// to hydrate the in-memory [ModuleProgress] counter on dashboard load.
  Future<int> fetchCompletedCount(String uid) async {
    final snapshot = await _moduleProgressCollection(uid).where('status', isEqualTo: 'completed').get();
    return snapshot.docs.length;
  }

  /// All saved answers for a module (optionally filtered to one `stage`),
  /// shaped for the `generateInsight` Cloud Function — the `updatedAt`
  /// server timestamp is dropped since it doesn't round-trip through JSON.
  Future<List<Map<String, dynamic>>> fetchAnswers(String uid, String moduleId, {int? stage}) async {
    Query<Map<String, dynamic>> query = _moduleDoc(uid, moduleId).collection('answers');
    if (stage != null) query = query.where('stage', isEqualTo: stage);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return <String, dynamic>{
        'questionKey': doc.id,
        'type': data['type'],
        'value': data['value'],
        if (data['stage'] != null) 'stage': data['stage'],
        if (data['questionNumber'] != null) 'questionNumber': data['questionNumber'],
      };
    }).toList();
  }

  /// Saved answers of a module whose `type` is one of [types] — used to pull
  /// just the computed `*_result` documents (or free-text answers) without
  /// reading every individual questionnaire item.
  Future<List<Map<String, dynamic>>> fetchAnswersOfType(String uid, String moduleId, List<String> types) async {
    final snapshot = await _moduleDoc(uid, moduleId).collection('answers').where('type', whereIn: types).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return <String, dynamic>{
        'questionKey': doc.id,
        'type': data['type'],
        'value': data['value'],
        if (data['questionNumber'] != null) 'questionNumber': data['questionNumber'],
      };
    }).toList();
  }

  Future<void> saveAnswer(
    String uid,
    String moduleId,
    String questionKey, {
    required String type,
    required Object value,
    int? stage,
    int? questionNumber,
  }) {
    return _moduleDoc(uid, moduleId).collection('answers').doc(questionKey).set({
      'type': type,
      'value': value,
      if (stage != null) 'stage': stage,
      if (questionNumber != null) 'questionNumber': questionNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Resets all module statuses back to `'locked'` for a retake. Answer
  /// history under each module is left in place rather than deleted.
  Future<void> resetAll(String uid) async {
    final batch = _firestore.batch();
    for (var i = 1; i <= 5; i++) {
      batch.set(_moduleDoc(uid, 'module$i'), {'status': 'locked', 'resume': FieldValue.delete()}, SetOptions(merge: true));
    }
    await batch.commit();
  }

  static const int monthlyRetakeLimit = 3;

  String get _currentMonthKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// How many retakes `users/{uid}` has used in the current calendar month
  /// (`retakeUsage: {month, count}`, reset implicitly once the month key
  /// changes).
  Future<int> retakesUsedThisMonth(String uid) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    final usage = snap.data()?['retakeUsage'] as Map<String, dynamic>?;
    if (usage == null || usage['month'] != _currentMonthKey) return 0;
    return (usage['count'] as num?)?.toInt() ?? 0;
  }

  /// Records one retake against this month's quota. Call before [resetAll].
  ///
  /// `retakeUsage` is server-write-only (see `firestore.rules` and
  /// `functions/account.js`'s `useRetake`) — the limit is enforced there,
  /// not just in the client's own pre-check, so a user can't reset their
  /// quota by writing to their own document directly. Throws a
  /// [FirebaseFunctionsException] with code `resource-exhausted` once the
  /// monthly limit is reached. [uid] is unused (the function always acts
  /// on the caller's own account) but kept so call sites didn't need to
  /// change.
  Future<void> recordRetake(String uid) async {
    final callable = _functions.httpsCallable('useRetake');
    await callable.call<Map<String, dynamic>>();
  }
}
