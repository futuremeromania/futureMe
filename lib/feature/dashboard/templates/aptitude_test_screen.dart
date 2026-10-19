import 'dart:async';

import 'package:flutter/material.dart';
import 'package:futureme/core/data/aptitude_test.dart';
import 'package:futureme/core/data/spatial_figures.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/spatial_figure_view.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The 30-minute session: all 24 exercises live inside this one screen.
///
/// One screen rather than 24 pushed routes, because the clock, the answers
/// and the ability to jump back to a skipped exercise all belong to the
/// session rather than to any single question.
///
/// The deadline is an absolute wall-clock time, not a counter that ticks
/// down. A counter would quietly stop while the app is backgrounded and
/// hand back minutes the person did not have — this way, leaving and
/// coming back costs exactly the time it took.
class AptitudeTestScreen extends StatefulWidget {
  const AptitudeTestScreen({super.key, required this.onFinished});

  final void Function(AptitudeResult result) onFinished;

  @override
  State<AptitudeTestScreen> createState() => _AptitudeTestScreenState();
}

class _AptitudeTestScreenState extends State<AptitudeTestScreen> {
  late final DateTime _deadline;
  late final DateTime _startedAt;
  Timer? _ticker;

  int _index = 0;
  final Map<int, int> _answers = {};
  final Map<int, int> _seconds = {};
  DateTime _itemEnteredAt = DateTime.now();
  bool _finished = false;

  AptitudeItem get _item => aptitudeItems[_index];

  Duration get _remaining {
    final left = _deadline.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  int get _answeredCount => _answers.length;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _deadline = _startedAt.add(
      const Duration(minutes: aptitudeTimeLimitMinutes),
    );
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining == Duration.zero) {
        _finish(AptitudeFinish.timeExpired);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Books the time spent on the exercise being left behind. Called on
  /// every move and once more at the end, so the totals add up to the
  /// session regardless of how the person moved around.
  void _bookTime() {
    final now = DateTime.now();
    _seconds[_item.id] =
        (_seconds[_item.id] ?? 0) + now.difference(_itemEnteredAt).inSeconds;
    _itemEnteredAt = now;
  }

  void _goTo(int index) {
    if (index == _index || index < 0 || index >= aptitudeItems.length) return;
    _bookTime();
    setState(() => _index = index);
  }

  void _finish(AptitudeFinish finish) {
    if (_finished) return;
    _finished = true;
    _bookTime();
    _ticker?.cancel();
    widget.onFinished(
      scoreAptitudeTest(
        answers: _answers,
        seconds: _seconds,
        finish: finish,
        totalSeconds: DateTime.now().difference(_startedAt).inSeconds,
      ),
    );
  }

  Future<void> _confirmFinish() async {
    final unanswered = aptitudeItems.length - _answeredCount;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Închei proba?",
          style: TextStyle(
            color: AppColors.uiHeading,
            fontSize: 20,
            fontFamily: AppFonts.heading,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          unanswered == 0
              ? "Ai răspuns la toate cele ${aptitudeItems.length} exerciții. După ce închei, răspunsurile nu mai pot fi modificate."
              : "Ai $unanswered ${unanswered == 1 ? 'exercițiu' : 'exerciții'} fără răspuns. După ce închei, răspunsurile nu mai pot fi modificate.",
          style: const TextStyle(
            color: AppColors.uiHeadingSmall,
            fontSize: 14,
            fontFamily: AppFonts.body,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Mai verific",
              style: TextStyle(
                color: AppColors.uiHeadingSmall,
                fontFamily: AppFonts.body,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Închei proba",
              style: TextStyle(
                color: AppColors.grad1,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _finish(AptitudeFinish.completedByUser);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _remaining;
    final lowOnTime = remaining.inMinutes < 5;

    // The session cannot be paused or resumed, so the system back gesture
    // must not be able to walk out of it half-finished.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Exercițiul ${_index + 1} din ${aptitudeItems.length}",
                        style: const TextStyle(
                          color: AppColors.uiHeadingSmall,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: lowOnTime
                            ? AppColors.insightWarmBg
                            : AppColors.faint,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: lowOnTime
                                ? AppColors.errorFg
                                : AppColors.uiHeadingSmall,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDuration(remaining),
                            style: TextStyle(
                              color: lowOnTime
                                  ? AppColors.errorFg
                                  : AppColors.uiHeading,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / aptitudeItems.length,
                    minHeight: 6,
                    backgroundColor: AppColors.faint,
                    valueColor: const AlwaysStoppedAnimation(AppColors.grad1),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_item.category.label} · ${_item.title}",
                        style: const TextStyle(
                          color: AppColors.grad1,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _item.prompt,
                        style: const TextStyle(
                          color: AppColors.uiHeading,
                          fontSize: 18,
                          fontFamily: AppFonts.heading,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      if (_item.promptFigure != null) ...[
                        const SizedBox(height: 16),
                        _Figure(figure: _item.promptFigure!, height: 200),
                      ],
                      const SizedBox(height: 20),
                      for (int i = 0; i < _item.options.length; i++) ...[
                        _OptionCard(
                          letter: aptitudeOptionLetters[i],
                          label: _item.options[i],
                          figure: _item.optionFigures == null
                              ? null
                              : _item.optionFigures![i],
                          selected: _answers[_item.id] == i,
                          onTap: () => setState(() {
                            // Tapping the chosen option again clears it, so
                            // an accidental answer can be taken back rather
                            // than only replaced.
                            if (_answers[_item.id] == i) {
                              _answers.remove(_item.id);
                            } else {
                              _answers[_item.id] = i;
                            }
                          }),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        "Toate exercițiile",
                        style: TextStyle(
                          color: AppColors.uiHeadingSmall,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (int i = 0; i < aptitudeItems.length; i++)
                            _IndexChip(
                              number: i + 1,
                              current: i == _index,
                              answered: _answers.containsKey(
                                aptitudeItems[i].id,
                              ),
                              onTap: () => _goTo(i),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  children: [
                    if (_index > 0) ...[
                      GestureDetector(
                        onTap: () => _goTo(_index - 1),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: AppColors.uiHeadingSmall,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: _index + 1 < aptitudeItems.length
                          ? PrimaryButton(
                              content: _answers.containsKey(_item.id)
                                  ? "Continuă"
                                  : "Sari peste",
                              onpressed: () => _goTo(_index + 1),
                            )
                          : PrimaryButton(
                              content: "Termină proba",
                              onpressed: _confirmFinish,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final minutes = d.inMinutes.toString().padLeft(2, '0');
  final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}

class _Figure extends StatelessWidget {
  const _Figure({required this.figure, this.height = 180});

  final SpatialFigure figure;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SpatialFigureView(figure: figure, height: height),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.letter,
    required this.label,
    required this.selected,
    required this.onTap,
    this.figure,
  });

  final String letter;
  final String label;

  /// When the option is a shape, this is drawn instead of [label]. The
  /// label still exists — the review screen has to be able to say in words
  /// which one was picked.
  final SpatialFigure? figure;

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.faint : Colors.white,
          border: Border.all(
            color: selected ? AppColors.grad1 : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.grad1 : AppColors.faint,
                shape: BoxShape.circle,
              ),
              child: Text(
                letter,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.uiHeadingSmall,
                  fontSize: 14,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: figure != null
                  ? SpatialFigureView(figure: figure!, height: 110)
                  : Text(
                      label,
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 15,
                        fontFamily: AppFonts.body,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndexChip extends StatelessWidget {
  const _IndexChip({
    required this.number,
    required this.current,
    required this.answered,
    required this.onTap,
  });

  final int number;
  final bool current;
  final bool answered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: answered ? AppColors.faint : Colors.white,
          border: Border.all(
            color: current ? AppColors.grad1 : AppColors.border,
            width: current ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$number",
          style: TextStyle(
            color: answered ? AppColors.uiHeading : AppColors.uiHeadingSmall,
            fontSize: 13,
            fontFamily: AppFonts.body,
            fontWeight: answered || current ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
