import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/templates/module_break_screen.dart';

/// Where the user left off inside a module — see
/// [ModuleProgressRepository.saveResume] for what each field means.
class ResumePoint {
  const ResumePoint({
    required this.stage,
    required this.index,
    required this.answers,
  });

  final int stage;
  final int index;
  final Map<String, dynamic> answers;

  /// The stage answers as item number → value, the shape every stage's
  /// question loop carries forward.
  Map<int, T> answersAs<T>() => {
    for (final entry in answers.entries)
      if (int.tryParse(entry.key) != null && entry.value is T)
        int.parse(entry.key): entry.value as T,
  };
}

/// Fire-and-forget: records that the next thing to show in [moduleId] is
/// question [index] of [stage], with [answers] collected so far.
void saveResumePoint(
  String moduleId,
  int stage,
  int index, [
  Map<int, Object> answers = const {},
]) {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return;
  getIt<ModuleProgressRepository>().saveResume(
    uid,
    moduleId,
    stage: stage,
    index: index,
    answers: {for (final entry in answers.entries) '${entry.key}': entry.value},
  );
}

Future<ResumePoint?> loadResumePoint(String moduleId) async {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return null;
  try {
    final data = await getIt<ModuleProgressRepository>().fetchResume(
      uid,
      moduleId,
    );
    if (data == null) return null;
    final stage = (data['stage'] as num?)?.toInt();
    final index = (data['index'] as num?)?.toInt();
    if (stage == null || index == null) return null;
    final answers = data['answers'];
    return ResumePoint(
      stage: stage,
      index: index,
      answers: answers is Map ? Map<String, dynamic>.from(answers) : const {},
    );
  } catch (_) {
    // Offline or unreadable: starting from the module's beginning is
    // better than not starting at all.
    return null;
  }
}

/// Opens [open] on top of an empty placeholder route instead of directly
/// on [context]. The flow functions that end a stage were written to be
/// called from the last question and so replace the current route; when
/// a stage is resumed straight from the dashboard, the placeholder is what
/// gets replaced — never the dashboard itself.
void openOverPlaceholder(
  BuildContext context,
  void Function(BuildContext) open,
) {
  Navigator.push(
    context,
    PageRouteBuilder<void>(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, _, __) => _Placeholder(onReady: open),
    ),
  );
}

class _Placeholder extends StatefulWidget {
  const _Placeholder({required this.onReady});

  final void Function(BuildContext) onReady;

  @override
  State<_Placeholder> createState() => _PlaceholderState();
}

class _PlaceholderState extends State<_Placeholder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onReady(context);
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: AppColors.background);
}

/// The mid-questionnaire rest screen. "Continuă" replaces it with the next
/// question (so going back from there returns to the question before the
/// break, not to the break); "Revin mai târziu" goes home — the resume
/// point was already saved when the previous answer was given.
void openQuestionBreak(
  BuildContext context, {
  required String title,
  required String headerImage,
  String? message,
  required void Function(BuildContext context) openNext,
}) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => ModuleBreakScreen(
        title: title,
        headerImage: headerImage,
        message: message ?? defaultBreakMessage,
        onContinue: () => openNext(context),
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

/// Reopens a questionnaire stage at a saved [ResumePoint]: index 0 is the
/// stage's introduction, 1..[length]-1 the next unanswered question, and
/// [length] means every question was answered, so the stage's ending is
/// shown again from the saved answers. A point whose answers don't add up
/// (fewer saved answers than questions passed) restarts the stage rather
/// than scoring an incomplete set.
void resumeStage(
  BuildContext context,
  ResumePoint point, {
  required int length,
  required void Function(BuildContext context) intro,
  required void Function(BuildContext context, int index) question,
  required void Function(BuildContext context) complete,
  bool checkAnswers = true,
}) {
  final index = point.index;
  final consistent = !checkAnswers || point.answers.length >= index;
  if (index <= 0 || !consistent) {
    intro(context);
  } else if (index < length) {
    question(context, index);
  } else {
    openOverPlaceholder(context, complete);
  }
}
