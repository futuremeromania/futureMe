import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futureme/core/chat/chat_api_config.dart';
import 'package:injectable/injectable.dart';

class ChatApiReply {
  const ChatApiReply({required this.answer, required this.sources});

  final String answer;

  /// Knowledge-base files the answer was grounded in.
  final List<String> sources;
}

/// A failure the chat screen can show to the user as-is.
class ChatApiException implements Exception {
  const ChatApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Client for `futureme-api`'s `POST /chat`.
///
/// Contract (see `futureme-api/API.md`): the body is `{sessionId, message,
/// result?}` and the reply is `{answer, sources}`. Every request carries the
/// signed-in user's Firebase ID token as `Authorization: Bearer <token>`;
/// the server rejects anything without a valid one with 401. The server keeps the last
/// `result` it received per `sessionId` and reuses it for later messages, so
/// `result` only needs sending when it is new or has changed. Errors come
/// back as `{error: "<Romanian text>"}` with 400 (bad input), 502 (Claude
/// failed) or 503 (Claude not configured).
@lazySingleton
class ChatApiService {
  ChatApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ChatApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 15),
          // Retrieval + a Claude round trip; the server sets no cap of its own.
          receiveTimeout: const Duration(seconds: 60),
          contentType: Headers.jsonContentType,
        ),
      ) {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: _attachIdToken));
  }

  final Dio _dio;

  /// Proves to the server who is asking. The server verifies this token
  /// with Firebase and takes the user's identity from it, so a request can
  /// no longer claim to be anyone it likes — before this, the only thing
  /// naming the user was a `sessionId` field the caller filled in freely.
  ///
  /// `getIdToken` hands back the cached token and refreshes it on its own
  /// once it nears expiry. If fetching it fails, the request still goes
  /// out without it: the server then answers 401, which surfaces as a
  /// message the user can act on, rather than the chat hanging.
  static Future<void> _attachIdToken(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    } catch (_) {
      // Sent without a token; see above.
    }
    handler.next(options);
  }

  /// [history] is the last few messages before [message] (`role` user or
  /// assistant, `text`), so the reply follows the conversation.
  Future<ChatApiReply> send({
    required String sessionId,
    required String message,
    Object? result,
    List<Map<String, String>> history = const [],
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/chat',
        data: {
          'sessionId': sessionId,
          'message': message,
          if (result != null) 'result': result,
          if (history.isNotEmpty) 'history': history,
        },
      );
      final data = response.data;
      final answer = (data?['answer'] as String?)?.trim() ?? '';
      if (answer.isEmpty) throw const ChatApiException('Nu am primit un răspuns. Încearcă din nou.');
      final sources = ((data?['sources'] as List?) ?? const []).map((e) => e.toString()).toList();
      return ChatApiReply(answer: answer, sources: sources);
    } on DioException catch (e) {
      throw ChatApiException(_messageFor(e));
    }
  }

  /// Asks the chat server to delete everything it keeps for the signed-in
  /// user (their conversations and the result context sent with them).
  /// Part of account deletion; throws [ChatApiException] if the server
  /// did not confirm, so the account is never deleted with the chat data
  /// left behind.
  Future<void> deleteMyData() async {
    try {
      // An empty JSON body rather than none: the server refuses a JSON
      // request whose body is missing.
      await _dio.delete<void>('/session', data: const <String, dynamic>{});
    } on DioException catch (e) {
      throw ChatApiException(_messageFor(e));
    }
  }

  String _messageFor(DioException e) {
    final body = e.response?.data;
    final serverMessage = body is Map ? body['error'] : null;
    if (serverMessage is String && serverMessage.isNotEmpty) return serverMessage;
    if (e.response?.statusCode == 401) return 'Nu te-am putut identifica. Ieși din chat și intră din nou.';
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'Răspunsul durează mai mult decât de obicei. Încearcă din nou.',
      DioExceptionType.connectionError => 'Nu mă pot conecta acum. Verifică conexiunea la internet și încearcă din nou.',
      _ => 'Ceva nu a mers bine. Încearcă din nou.',
    };
  }
}
