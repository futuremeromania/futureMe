import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';

const List<IconData> _insightIcons = [
  Icons.wb_sunny_outlined,
  Icons.psychology_outlined,
  Icons.explore_outlined,
  Icons.balance_outlined,
  Icons.bolt_outlined,
  Icons.handshake_outlined,
];

SummaryLevel? _toSummaryLevel(InsightLevel? level) => switch (level) {
  InsightLevel.low => SummaryLevel.low,
  InsightLevel.medium => SummaryLevel.medium,
  InsightLevel.high => SummaryLevel.high,
  null => null,
};

/// Maps a Claude-generated [GeneratedInsight] to the [SummaryItem] list the
/// feedback screens render.
List<SummaryItem> insightToSummaryItems(GeneratedInsight insight) => [
  for (int i = 0; i < insight.items.length; i++)
    SummaryItem(
      icon: _insightIcons[i % _insightIcons.length],
      title: insight.items[i].title,
      description: insight.items[i].description,
      level: _toSummaryLevel(insight.items[i].level),
    ),
];

/// Maps a Claude-generated [GeneratedInsight] to the [ConnectionItem] list
/// the module "Final Feedback" synthesis screens render.
List<ConnectionItem> insightToConnectionItems(GeneratedInsight insight) => [
  for (int i = 0; i < insight.items.length; i++)
    ConnectionItem(
      icon: _insightIcons[i % _insightIcons.length],
      title: insight.items[i].title,
      description: insight.items[i].description,
    ),
];

/// Loading gate: reads the user's saved answers for [scope] / [moduleId]
/// (optionally a single [stage]), asks the `generateInsight` Cloud Function
/// for a per-user interpretation, then replaces itself with
/// `builder(context, insight)`.
///
/// When the feedback can't be had in time and [onContinue] or [readOnly] is
/// set, the gate shows [InsightPendingScreen] instead of a generic text: the
/// user can try again or go on, and finds the feedback on the dashboard
/// later (the server keeps working and saves it). Otherwise `insight` is
/// **null** and the builder renders the screen's fixed fallback content.
class InsightFeedbackGate extends StatefulWidget {
  const InsightFeedbackGate({
    super.key,
    required this.scope,
    required this.moduleId,
    required this.builder,
    this.stage,
    this.alsoFromModules,
    this.onlyTypes,
    this.loadingLabel = "Feedback",
    this.onContinue,
    this.readOnly = false,
  });

  /// Where the screen's own button would have gone, for going on without
  /// the feedback (see [InsightPendingScreen]).
  final void Function(BuildContext context)? onContinue;

  /// Opened from the dashboard: going on means going back.
  final bool readOnly;

  final String scope;
  final String moduleId;
  final int? stage;

  /// When set, only saved answers of these `type`s are sent to the model.
  /// The Module 3 synthesis uses it to send the computed `*_result`
  /// documents and nothing else: its specification forbids the model from
  /// seeing the raw item answers, so they must not leave the device.
  final List<String>? onlyTypes;

  /// Extra module ids whose saved answers are merged in alongside
  /// [moduleId]'s — used by the Module 5 synthesis screens, which have no
  /// questions of their own and interpret the whole journey.
  final List<String>? alsoFromModules;

  final String loadingLabel;
  final Widget Function(BuildContext context, GeneratedInsight? insight)
  builder;

  @override
  State<InsightFeedbackGate> createState() => _InsightFeedbackGateState();
}

class _InsightFeedbackGateState extends State<InsightFeedbackGate> {
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    GeneratedInsight? insight;
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid != null) {
      try {
        final repo = getIt<ModuleProgressRepository>();
        final types = widget.onlyTypes;
        final answers = types != null
            ? await repo.fetchAnswersOfType(uid, widget.moduleId, types)
            : await repo.fetchAnswers(
                uid,
                widget.moduleId,
                stage: widget.stage,
              );
        final extraModuleIds = widget.alsoFromModules ?? const <String>[];
        if (extraModuleIds.isNotEmpty) {
          // Across several modules every answer carries its module id: item
          // keys like `stage1_q3` repeat from one module to the next.
          for (var i = 0; i < answers.length; i++) {
            answers[i] = {...answers[i], 'moduleId': widget.moduleId};
          }
          for (final extraModuleId in extraModuleIds) {
            for (final answer in await repo.fetchAnswers(uid, extraModuleId)) {
              answers.add({...answer, 'moduleId': extraModuleId});
            }
          }
        }
        if (answers.isNotEmpty) {
          insight = await getIt<AiContentRepository>().insight(
            scope: widget.scope,
            answers: answers,
          );
        }
      } catch (_) {
        insight = null;
      }
    }
    if (!mounted) return;
    if (insight == null && (widget.onContinue != null || widget.readOnly)) {
      setState(() => _pending = true);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.builder(context, insight)),
    );
  }

  @override
  Widget build(BuildContext context) => _pending
      ? InsightPendingScreen(
          moduleLabel: widget.loadingLabel,
          readOnly: widget.readOnly,
          onRetry: () {
            setState(() => _pending = false);
            _resolve();
          },
          onContinue: widget.readOnly ? () => Navigator.pop(context) : () => widget.onContinue!(context),
        )
      : ModuleLoadingScreen(
    moduleLabel: widget.loadingLabel,
    title: "Pregătim feedbackul tău",
    description: "Ne uităm peste răspunsurile tale. Durează câteva secunde.",
    reminderText: "Acesta este un reper, nu o etichetă.",
  );
}

/// Shown when a feedback or synthesis isn't ready within the wait: the
/// server keeps working on it and saves it, so the user can try again now
/// or go on and read it later from the dashboard.
class InsightPendingScreen extends StatelessWidget {
  const InsightPendingScreen({
    super.key,
    required this.moduleLabel,
    required this.onRetry,
    required this.onContinue,
    this.readOnly = false,
    this.subject = "rezumatul",
  });

  final String moduleLabel;
  final VoidCallback onRetry;
  final VoidCallback onContinue;
  final bool readOnly;

  /// What is being prepared, as it reads in the sentence ("rezumatul",
  /// "feedbackul").
  final String subject;

  @override
  Widget build(BuildContext context) {
    final message = readOnly
        ? "Mai durează puțin să pregătim $subject. Poți reveni peste câteva minute din dashboard sau poți încerca din nou acum."
        : "Mai durează puțin să pregătim $subject. Poți continua acum și îl vei găsi gata, peste câteva minute, în dashboard, la modulul finalizat. Sau poți încerca din nou acum.";
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const SunBadgeIcon(),
                    const SizedBox(height: 32),
                    const PageTitle(content: "Mai durează puțin", width: 274),
                    const SizedBox(height: 24),
                    CenterText(content: message),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(content: readOnly ? "Înapoi la parcurs" : "Continuă", onpressed: onContinue),
                  const SizedBox(height: 8),
                  TagButton(content: "Încearcă din nou", onTap: onRetry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
