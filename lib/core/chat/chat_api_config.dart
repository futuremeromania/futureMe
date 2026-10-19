/// Where the `futureme-api` server (`POST /chat`) is reachable.
///
/// Override at build/run time without touching code:
///   flutter run --dart-define=FUTUREME_API_URL=https://api.example.com
///
/// Defaults to the production server. Caddy on the VPS terminates HTTPS with
/// a Let's Encrypt certificate and forwards to the chat server on port 3000,
/// which is not meant to be reached directly: iOS and Android both refuse
/// plain HTTP, so the app must only ever talk to the HTTPS name.
class ChatApiConfig {
  ChatApiConfig._();

  static const _override = String.fromEnvironment('FUTUREME_API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return 'https://api.futuremeromania.ro';
  }

  /// Limits enforced by the server (`src/server.ts`); checked client-side so
  /// a request that would be rejected never leaves the device.
  static const maxMessageLength = 10000;
  static const maxResultLength = 20000;
}
