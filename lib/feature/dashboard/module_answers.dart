import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';

/// Fire-and-forget "module started" marker, called when a module's
/// Introduction screen is first advanced past.
void markModuleStarted(String moduleId) {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return;
  getIt<ModuleProgressRepository>().markStarted(uid, moduleId);
}

/// Fire-and-forget answer autosave shared by every module flow's
/// `onContinue`/`onAutosave` callbacks — those callbacks are synchronous
/// (`ValueChanged<...>`), so this isn't awaited by callers.
void saveModuleAnswer(
  String moduleId,
  String questionKey, {
  required String type,
  required Object value,
  int? stage,
  int? questionNumber,
}) {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return;
  getIt<ModuleProgressRepository>().saveAnswer(
    uid,
    moduleId,
    questionKey,
    type: type,
    value: value,
    stage: stage,
    questionNumber: questionNumber,
  );
}
