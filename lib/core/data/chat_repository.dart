import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

/// Owns `users/{uid}/chatMessages`. One flat, timestamp-ordered log per
/// user; `contextLabel` records which screen/module the message was sent
/// from. This is only the on-device-visible history so a conversation
/// survives closing the screen — the answers themselves come from
/// `futureme-api` (`ChatApiService`), which keeps no message history of its
/// own.
///
/// Messages are kept for [retention]: each one carries an `expireAt` date
/// and a Firestore TTL policy on `chatMessages.expireAt` deletes it after
/// that. The user can also delete the whole conversation ([clearHistory]).
@lazySingleton
class ChatRepository {
  /// How long a chat message is kept.
  static const Duration retention = Duration(days: 183);

  ChatRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String uid) =>
      _firestore.collection('users').doc(uid).collection('chatMessages');

  Future<List<({String sender, String text})>> loadHistory(String uid, String contextLabel) async {
    final snapshot = await _messages(
      uid,
    ).where('contextLabel', isEqualTo: contextLabel).orderBy('createdAt').limit(200).get();
    // Messages saved before the retention rule existed get their expiry now,
    // counted from when they were written.
    final missing = snapshot.docs.where((doc) => doc.data()['expireAt'] == null).toList();
    if (missing.isNotEmpty) {
      final batch = _firestore.batch();
      for (final doc in missing) {
        final created = doc.data()['createdAt'];
        final from = created is Timestamp ? created.toDate() : DateTime.now();
        batch.update(doc.reference, {'expireAt': Timestamp.fromDate(from.add(retention))});
      }
      batch.commit().ignore();
    }
    final cutoff = DateTime.now().subtract(retention);
    return snapshot.docs
        // The TTL sweep can lag a day behind; an expired message is never shown.
        .where((doc) {
          final created = doc.data()['createdAt'];
          return created is! Timestamp || created.toDate().isAfter(cutoff);
        })
        .map((doc) => (sender: doc['sender'] as String, text: doc['text'] as String))
        .toList();
  }

  /// Deletes every saved message of this conversation.
  Future<void> clearHistory(String uid, String contextLabel) async {
    while (true) {
      final snapshot = await _messages(uid).where('contextLabel', isEqualTo: contextLabel).limit(400).get();
      if (snapshot.docs.isEmpty) return;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  Future<void> saveMessage(String uid, {required String contextLabel, required String sender, required String text}) {
    return _messages(uid).add({
      'sender': sender,
      'text': text,
      'contextLabel': contextLabel,
      'createdAt': FieldValue.serverTimestamp(),
      'expireAt': Timestamp.fromDate(DateTime.now().add(retention)),
    });
  }
}
