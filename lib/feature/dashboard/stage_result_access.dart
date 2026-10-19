import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// Label of the button on a result opened from the dashboard: a finished
/// stage can be looked at again, never continued or retaken.
const String readOnlyBackLabel = "Înapoi la parcurs";

/// Opens a finished stage's result from the dashboard, read-only.
///
/// [load] fetches what the screen needs (null when it isn't there); while it
/// runs a plain loading screen is shown, which is then replaced by [build]'s
/// screen. [build] gets a `back` action that returns to the dashboard from
/// however many result screens deep the user went.
void openStageResult<T extends Object>(
  BuildContext context, {
  required Future<T?> Function(String uid) load,
  required Widget Function(BuildContext context, T data, VoidCallback back)
  build,
  String emptyMessage = "Rezultatul acestei etape nu a putut fi încărcat.",
}) {
  final navigator = Navigator.of(context);
  final dashboard = ModalRoute.of(context);
  void back() => navigator.popUntil(
    (route) => dashboard == null ? route.isFirst : route == dashboard,
  );

  navigator.push(
    MaterialPageRoute<void>(
      builder: (context) =>
          _StageResultGate<T>(load: load, build: build, back: back, emptyMessage: emptyMessage),
    ),
  );
}

class _StageResultGate<T extends Object> extends StatefulWidget {
  const _StageResultGate({
    required this.load,
    required this.build,
    required this.back,
    required this.emptyMessage,
  });

  /// Shown when [load] finds nothing to open.
  final String emptyMessage;

  final Future<T?> Function(String uid) load;
  final Widget Function(BuildContext context, T data, VoidCallback back) build;
  final VoidCallback back;

  @override
  State<_StageResultGate<T>> createState() => _StageResultGateState<T>();
}

class _StageResultGateState<T extends Object>
    extends State<_StageResultGate<T>> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    T? data;
    try {
      data = uid == null ? null : await widget.load(uid);
    } catch (_) {
      data = null;
    }
    if (!mounted) return;
    if (data == null) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text(widget.emptyMessage)),
      );
      return;
    }
    final loaded = data;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => widget.build(context, loaded, widget.back),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors.background,
    body: Center(child: CircularProgressIndicator()),
  );
}

/// A stage's saved item answers (`stage{N}_q{number}`), keyed by item
/// number, each read from its stored value by [read]. The stage's result
/// document and anything [read] can't use are skipped.
Future<Map<int, V>> loadStageAnswers<V>(
  String uid,
  String moduleId,
  int stage,
  V? Function(Map<String, dynamic> value) read,
) async {
  final rows = await getIt<ModuleProgressRepository>().fetchAnswers(
    uid,
    moduleId,
    stage: stage,
  );
  final prefix = 'stage${stage}_q';
  final answers = <int, V>{};
  for (final row in rows) {
    final key = row['questionKey'] as String? ?? '';
    final number = row['questionNumber'];
    final value = row['value'];
    if (!key.startsWith(prefix) || number is! num || value is! Map) continue;
    final read0 = read(Map<String, dynamic>.from(value));
    if (read0 != null) answers[number.toInt()] = read0;
  }
  return answers;
}

/// The 1-5 answer of a scale item.
int? scaleAnswerOf(Map<String, dynamic> value) =>
    (value['answer'] as num?)?.toInt();

/// The stored value of one saved answer document of [type], or null.
Future<Map<String, dynamic>?> loadSavedValue(
  String uid,
  String moduleId,
  String type,
) async {
  final rows = await getIt<ModuleProgressRepository>().fetchAnswersOfType(
    uid,
    moduleId,
    [type],
  );
  if (rows.isEmpty) return null;
  final value = rows.first['value'];
  return value is Map ? Map<String, dynamic>.from(value) : null;
}
