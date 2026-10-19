import 'dart:convert';

import 'package:futureme/core/chat/chat_api_config.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:injectable/injectable.dart';

/// Assembles the `result` that `POST /chat` expects: the user's combined
/// outcome across Modules 1-5, which the server keeps per `sessionId` and uses
/// as the main reference for every reply (and to route to the matching
/// knowledge-base documents).
///
/// Built from what the app has actually saved for the user:
///  - Module 1: the user's own written answers.
///  - Module 2, stages 1-4: the scored MBTI, Big Five, cognitive-style and
///    decision-style results.
///  - Modules 3-5: the AI-written final report (`users/{uid}/reports/finalReport`,
///    generated from the answers of all five modules). Modules 3 and 4 and
///    Module 2's stages 5-6 store only raw, unlabelled scale picks (their
///    statements are still placeholders) and Module 5 stores no answers of its
///    own, so the report is what carries their outcome — sending the raw picks
///    would only give the model numbers it can't interpret.
///
/// Keys are Romanian words on purpose: the server matches keywords like
/// "mbti", "personalitate" and "stil decizional" against this text to pick
/// which documents to search.
@lazySingleton
class ChatSessionResultBuilder {
  ChatSessionResultBuilder(this._progress, this._users);

  final ModuleProgressRepository _progress;
  final UserRepository _users;

  static const _maxReflectionLength = 800;
  static const _maxReportSectionLength = 1200;

  /// The server rejects a result over its limit outright, so stay clear of it.
  static const _budget = ChatApiConfig.maxResultLength - 1000;

  /// Returns null when nothing is saved yet (or it can't be read), in which
  /// case the server falls back to whatever it already holds for the session.
  Future<Map<String, dynamic>?> build(String uid) async {
    final result = <String, dynamic>{};
    // Each part is read on its own so one failing (e.g. the report not
    // generated) doesn't throw away the rest.
    await _guard(() async => result.addAll(await _assessments(uid)));
    await _guard(() async {
      final report = await _finalReport(uid);
      if (report != null) result['raport_final'] = report;
    });
    if (result.isEmpty) return null;
    return _fitToBudget(result);
  }

  Future<void> _guard(Future<void> Function() task) async {
    try {
      await task();
    } catch (_) {}
  }

  /// Trims the unbounded parts, least valuable first: the free-text answers
  /// (already summarised by the report) go before the report itself shrinks.
  Map<String, dynamic> _fitToBudget(Map<String, dynamic> result) {
    bool fits() => jsonEncode(result).length <= _budget;
    if (fits()) return result;
    result.remove('raspunsuri_modul_1');
    if (fits()) return result;
    final report = result['raport_final'];
    if (report is Map<String, dynamic>) {
      final sections = (report['sectiuni'] as List?) ?? const [];
      result['raport_final'] = {
        'rezumat': report['rezumat'],
        'sectiuni': [
          for (final s in sections) {'titlu': (s as Map)['titlu'], 'text': _truncate('${s['text']}', 400)},
        ],
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> _assessments(String uid) async {
    final module2 = await _progress.fetchAnswersOfType(uid, 'module2', const [
      'mbti_result',
      'big_five_result',
      'cognitive_style_result',
      'decision_style_result',
    ]);
    final module1 = await _progress.fetchAnswersOfType(uid, 'module1', const ['text']);

    final assessments = <String, dynamic>{};
    for (final answer in module2) {
      final value = Map<String, dynamic>.from((answer['value'] as Map?) ?? const {});
      switch (answer['type']) {
        case 'mbti_result':
          assessments['mbti'] = value;
        case 'big_five_result':
          // `recoded` is 50 per-item scores — noise next to the dimensions.
          assessments['personalitate_big_five'] = value['dimensions'];
        case 'cognitive_style_result':
          assessments['stil_cognitiv'] = {
            'poli': value['poles'],
            'dimensiuni': {
              for (final e in Map<String, dynamic>.from((value['dimensions'] as Map?) ?? const {}).entries)
                e.key: {...Map<String, dynamic>.from(e.value as Map)}..remove('feedbackId'),
            },
          };
        case 'decision_style_result':
          assessments['stil_decizional'] = value['styles'];
      }
    }

    module1.sort((a, b) => ((a['questionNumber'] as num?) ?? 0).compareTo((b['questionNumber'] as num?) ?? 0));
    final reflections = [
      for (final answer in module1)
        if ((answer['value'] as String?)?.trim().isNotEmpty ?? false)
          {'intrebarea': answer['questionNumber'], 'raspuns': _truncate((answer['value'] as String).trim(), _maxReflectionLength)},
    ];
    if (reflections.isNotEmpty) assessments['raspunsuri_modul_1'] = reflections;

    return assessments;
  }

  Future<Map<String, dynamic>?> _finalReport(String uid) async {
    final report = await _users.fetchFinalReport(uid);
    if (report == null || report['status'] != 'ready') return null;
    final sections = [
      for (final s in (report['sections'] as List?) ?? const [])
        if (s is Map) {'titlu': s['title'], 'text': _truncate('${s['body'] ?? ''}', _maxReportSectionLength)},
    ];
    final summary = (report['summary'] as String?)?.trim();
    if (sections.isEmpty && (summary == null || summary.isEmpty)) return null;
    return {if (summary != null && summary.isNotEmpty) 'rezumat': summary, 'sectiuni': sections};
  }

  String _truncate(String text, int max) => text.length <= max ? text : '${text.substring(0, max)}…';
}
