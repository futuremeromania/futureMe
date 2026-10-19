import Flutter
import UIKit
#if canImport(DeclaredAgeRange)
import DeclaredAgeRange
#endif

/// Bridges Apple's `DeclaredAgeRange` framework (iOS 26+) to Dart over a
/// hand-rolled method channel — no third-party plugin, since the only
/// Flutter wrapper on pub.dev is a days-old solo-maintainer package that
/// also forces a Flutter SDK upgrade this project isn't ready for.
///
/// This is wired as a *corroborating* signal alongside the app's existing
/// self-reported age bracket (see `AgeSet` in
/// `lib/feature/age_gate/age_set_screen.dart`), never a hard requirement —
/// every failure path below (old iOS, framework unavailable, user
/// declined, unexpected error) resolves the call with `nil`, and the Dart
/// side simply falls back to the self-reported value. `#if
/// canImport(DeclaredAgeRange)` keeps this file compiling on any Xcode
/// that predates the iOS 26 SDK; `@available` guards keep it safe to run
/// on devices older than iOS 26.
final class AgeRangeSignalChannel: NSObject {
  static let channelName = "futureme/age_range_signal"

  private static var retainedChannel: FlutterMethodChannel?
  private static var retainedInstance: AgeRangeSignalChannel?

  /// Call once from `AppDelegate` after the root `FlutterViewController`
  /// exists (the framework needs a presenting view controller to show its
  /// system age-sharing prompt).
  static func register(messenger: FlutterBinaryMessenger, viewController: UIViewController) {
    let instance = AgeRangeSignalChannel(viewController: viewController)
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler(instance.handle)
    // FlutterMethodChannel doesn't retain its handler's target, so hold
    // both here for the app's lifetime.
    retainedChannel = channel
    retainedInstance = instance
  }

  private let viewController: UIViewController

  private init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "requestAgeRange" else {
      result(FlutterMethodNotImplemented)
      return
    }

    guard let args = call.arguments as? [String: Any],
          let gates = args["gates"] as? [Int],
          !gates.isEmpty, gates.count <= 3
    else {
      result(FlutterError(code: "bad_args", message: "gates must be 1-3 ints", details: nil))
      return
    }

    #if canImport(DeclaredAgeRange)
    if #available(iOS 26.0, *) {
      Task { [viewController] in
        do {
          let payload = try await Self.requestAgeRange(gates: gates, viewController: viewController)
          result(payload)
        } catch {
          // Unavailable, cancelled, sandbox not configured, etc. — a
          // corroborating signal that failed to arrive, not an error the
          // caller needs to handle.
          result(nil)
        }
      }
      return
    }
    #endif
    result(nil)
  }

  #if canImport(DeclaredAgeRange)
  @available(iOS 26.0, *)
  private static func requestAgeRange(gates: [Int], viewController: UIViewController) async throws -> [String: Any] {
    let response: AgeRangeService.Response
    switch gates.count {
    case 1:
      response = try await AgeRangeService.shared.requestAgeRange(ageGates: gates[0], in: viewController)
    case 2:
      response = try await AgeRangeService.shared.requestAgeRange(ageGates: gates[0], gates[1], in: viewController)
    default:
      response = try await AgeRangeService.shared.requestAgeRange(ageGates: gates[0], gates[1], gates[2], in: viewController)
    }

    switch response {
    case .declinedSharing:
      return ["shared": false]
    case .sharing(let range):
      return [
        "shared": true,
        "lowerBound": range.lowerBound.map { $0 as Any } ?? NSNull(),
        "upperBound": range.upperBound.map { $0 as Any } ?? NSNull(),
        "declaration": String(describing: range.ageRangeDeclaration),
      ]
    @unknown default:
      return ["shared": false]
    }
  }
  #endif
}
