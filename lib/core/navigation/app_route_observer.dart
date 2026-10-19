import 'package:flutter/widgets.dart';

/// Lets a widget learn that another screen was pushed on top of its own.
///
/// `deactivate` fires only when a widget leaves the tree — on pop, or on a
/// `pushReplacement`. Pushing a new route leaves the screen underneath
/// mounted and untouched, which is why the audio on a "Complete" screen
/// kept playing over the module that followed: nothing on that screen was
/// ever told it had been covered.
///
/// Registered on the app's navigator; widgets that own playback subscribe
/// and stop themselves in `didPushNext`.
final RouteObserver<ModalRoute<void>> appRouteObserver = RouteObserver<ModalRoute<void>>();
