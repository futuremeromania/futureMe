import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';

/// In-memory progress tracker driving the Dashboard's 3 states (Figma
/// frames 61:271 "Start", 86:1433 "Module N Done", 496:2307 "Complete").
/// Backed by Firestore via [ModuleProgressRepository]: [hydrate] loads the
/// completed count on dashboard entry, and [markCompleted] writes through
/// so progress survives app restarts.
class ModuleProgress {
  ModuleProgress._();

  /// How many of the 5 modules have been fully completed (0-5).
  static int completedModules = 0;

  /// True when the module after the completed ones was left part-way, so
  /// the dashboard offers to continue it rather than to start it.
  static bool hasResume = false;

  /// Loads the completed-module count from Firestore for the current user.
  /// Call once when the dashboard is entered.
  static Future<void> hydrate() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid == null) return;
    completedModules = await getIt<ModuleProgressRepository>()
        .fetchCompletedCount(uid);
    hasResume = false;
    if (completedModules < 5) {
      try {
        hasResume =
            await getIt<ModuleProgressRepository>().fetchResume(
              uid,
              'module${completedModules + 1}',
            ) !=
            null;
      } catch (_) {
        hasResume = false;
      }
    }
  }

  static void markCompleted(int moduleNumber) {
    hasResume = false;
    if (moduleNumber > completedModules) completedModules = moduleNumber;
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid != null) {
      getIt<ModuleProgressRepository>().markCompleted(
        uid,
        'module$moduleNumber',
      );
    }
  }

  static bool get isAllComplete => completedModules >= 5;

  /// Resets local + remote progress for a retake.
  static Future<void> resetAll() async {
    completedModules = 0;
    hasResume = false;
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid != null) {
      await getIt<ModuleProgressRepository>().resetAll(uid);
    }
  }
}
