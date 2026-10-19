import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/chat/chat_api_config.dart';
import 'package:futureme/core/chat/chat_api_service.dart';
import 'package:futureme/core/chat/chat_session_result_builder.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/data/chat_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/profile/profile_screen.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';

enum ChatSender { bot, user }

/// A suggested first question, with the fixed FutureMe reply the app shows
/// for it. No model is called for that reply: the user's answer to it is
/// what reaches the AI, together with this exchange as context.
class StarterPrompt {
  const StarterPrompt(this.question, this.reply);

  final String question;
  final String reply;
}

/// How many earlier messages go with each request, so a short answer
/// ("concluzia despre leadership") is understood in context without the
/// whole conversation being sent (and paid for) every time.
const int _historyForContext = 8;

class ChatMessage {
  const ChatMessage({required this.sender, required this.text});

  final ChatSender sender;
  final String text;
}

/// Shared layout for the "Pre-Chat" (116:771) and "Chat" (116:920) Figma
/// frames — they're the same screen at different points in a
/// conversation, so one widget covers both: seed it with a single bot
/// greeting for the Pre-Chat entry state, or with a bot+user exchange
/// already in progress for the Chat state.
///
/// Replies come from `futureme-api`'s `POST /chat` (see [ChatApiService]).
/// This is the single chat at the end of the journey, not a per-module one:
/// the session id is the user's uid, and their combined Module 1-5 results
/// are sent as `result` with the first message of each opened chat so the
/// server personalises every answer with them. The server also remembers the
/// conversation under that session id, so the app only ever sends the new
/// message — the history shown here is just for display.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.contextLabel,
    required this.seedMessages,
    required this.starterPrompts,
    this.promptLabel = "Poți începe cu:",
  });

  /// Header subtitle pill; also keys the saved message history.
  final String contextLabel;
  final List<ChatMessage> seedMessages;
  final List<StarterPrompt> starterPrompts;
  final String promptLabel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<ChatMessage> _messages = List.of(widget.seedMessages);
  late final List<StarterPrompt> _prompts = List.of(widget.starterPrompts);
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _awaitingReply = false;
  String? _error;
  String? _unansweredMessage;

  /// Whether the server already holds this user's current questionnaire
  /// results. It keeps them per session, so they're only re-sent until one
  /// request succeeds with them — then just `sessionId` + `message`.
  bool _resultSynced = false;

  String? get _uid => getIt<AuthService>().currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final uid = _uid;
    if (uid == null) return;
    final history = await getIt<ChatRepository>().loadHistory(uid, widget.contextLabel);
    if (!mounted || history.isEmpty) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(
          history.map(
            (m) => ChatMessage(sender: m.sender == 'user' ? ChatSender.user : ChatSender.bot, text: m.text),
          ),
        );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _persist(ChatSender sender, String text) {
    final uid = _uid;
    if (uid == null) return;
    getIt<ChatRepository>().saveMessage(
      uid,
      contextLabel: widget.contextLabel,
      sender: sender == ChatSender.user ? 'user' : 'bot',
      text: text,
    );
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _awaitingReply) return;
    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: trimmed));
      _controller.clear();
    });
    _persist(ChatSender.user, trimmed);
    _requestReply(trimmed);
  }

  /// A starter question gets its fixed reply straight away, with no request
  /// to the server.
  void _sendStarter(StarterPrompt prompt) {
    if (_awaitingReply) return;
    setState(() {
      _messages
        ..add(ChatMessage(sender: ChatSender.user, text: prompt.question))
        ..add(ChatMessage(sender: ChatSender.bot, text: prompt.reply));
      _prompts.remove(prompt);
      _error = null;
    });
    _persist(ChatSender.user, prompt.question);
    _persist(ChatSender.bot, prompt.reply);
    _scrollToBottom();
  }

  /// The messages before the one being answered, oldest first.
  List<Map<String, String>> _historyBefore(String message) {
    final earlier = List.of(_messages);
    // The message being answered is the last user message; it is sent on
    // its own.
    final i = earlier.lastIndexWhere((m) => m.sender == ChatSender.user && m.text == message);
    if (i >= 0) earlier.removeRange(i, earlier.length);
    final recent = earlier.length > _historyForContext ? earlier.sublist(earlier.length - _historyForContext) : earlier;
    return [
      for (final m in recent) {'role': m.sender == ChatSender.user ? 'user' : 'assistant', 'text': m.text},
    ];
  }

  /// Asks the API to answer [message]. A failure leaves the user's message in
  /// the history and offers a retry rather than inventing a bot reply.
  Future<void> _requestReply(String message) async {
    setState(() {
      _awaitingReply = true;
      _error = null;
      _unansweredMessage = message;
    });
    _scrollToBottom();

    final uid = _uid;
    try {
      if (uid == null) throw const ChatApiException('Trebuie să fii autentificat ca să poți vorbi cu FutureMe.');

      final result = _resultSynced ? null : await getIt<ChatSessionResultBuilder>().build(uid);
      final reply = await getIt<ChatApiService>().send(
        sessionId: uid,
        message: message,
        result: result,
        history: _historyBefore(message),
      );
      if (result != null) _resultSynced = true;

      // Saved even if the screen was closed mid-request, so the history
      // reloaded next time still has the answer.
      _persist(ChatSender.bot, reply.answer);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(sender: ChatSender.bot, text: reply.answer));
        _awaitingReply = false;
        _unansweredMessage = null;
      });
    } on ChatApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _awaitingReply = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _awaitingReply = false;
        _error = 'Ceva nu a mers bine. Încearcă din nou.';
      });
    }
    _scrollToBottom();
  }

  /// Asks for confirmation, then deletes the saved conversation and starts
  /// the chat over from the greeting.
  Future<void> _confirmClear() async {
    if (_awaitingReply) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Ștergi conversația?"),
        content: const Text(
          "Toate mesajele din acest chat vor fi șterse definitiv. Rezultatele și raportul tău rămân neschimbate.\n\nChiar dacă nu o ștergi, conversația se păstrează cel mult 6 luni.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text("Renunță")),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Șterge", style: TextStyle(color: AppColors.errorFg)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final uid = _uid;
    try {
      if (uid != null) await getIt<ChatRepository>().clearHistory(uid, widget.contextLabel);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nu am putut șterge conversația. Încearcă din nou.")));
      return;
    }
    if (!mounted) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(widget.seedMessages);
      _prompts
        ..clear()
        ..addAll(widget.starterPrompts);
      _error = null;
      _unansweredMessage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Conversația a fost ștearsă.")));
  }

  void _retry() {
    final message = _unansweredMessage;
    if (message == null || _awaitingReply) return;
    _requestReply(message);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: "Șterge conversația",
                      onPressed: _confirmClear,
                      icon: const Icon(Icons.delete_outline, color: AppColors.uiHeadingSmall),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Chat FutureMe",
                        style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.faint,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          widget.contextLabel,
                          style: const TextStyle(color: AppColors.uiHeading, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final message in _messages) ...[_MessageBubble(message: message), const SizedBox(height: 16)],
                    if (_awaitingReply) ...[
                      const _MessageBubble(message: ChatMessage(sender: ChatSender.bot, text: "Mă gândesc la răspuns…")),
                      const SizedBox(height: 16),
                    ],
                    if (_error != null) ...[
                      _ErrorNotice(message: _error!, onRetry: _unansweredMessage == null ? null : _retry),
                      const SizedBox(height: 16),
                    ],
                    if (_prompts.isNotEmpty) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.promptLabel,
                          style: const TextStyle(
                            color: AppColors.uiHeadingSmall,
                            fontSize: 14,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final prompt in _prompts)
                              GestureDetector(
                                onTap: () => _sendStarter(prompt),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.faint,
                                    border: Border.all(color: AppColors.borderStrong),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    prompt.question,
                                    style: const TextStyle(
                                      color: AppColors.uiHeading,
                                      fontSize: 14,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w500,
                                      height: 1.29,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller,
                        inputFormatters: [LengthLimitingTextInputFormatter(ChatApiConfig.maxMessageLength)],
                        onSubmitted: _send,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "Întreabă ce vrei să clarifici...",
                          hintStyle: TextStyle(color: AppColors.container, fontFamily: AppFonts.body, fontSize: 16),
                        ),
                        style: const TextStyle(color: AppColors.dashboard, fontFamily: AppFonts.body, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _send(_controller.text),
                    child: Opacity(
                      opacity: _awaitingReply ? 0.5 : 1,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(gradient: AppColors.specialGradient, shape: BoxShape.circle),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppBottomNavBar(
              activeIndex: 1,
              onHomeTap: () => goToDashboard(context),
              onReportTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen())),
              onResourcesTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourcesScreen())),
              onProfileTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onRetry,
                child: const Text(
                  "Reîncearcă",
                  style: TextStyle(color: AppColors.grad1, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.grad1,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5)),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(child: Image.asset(AppAssets.moduleIcon, width: 40, height: 40, fit: BoxFit.cover)),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Text.rich(
              TextSpan(children: _withBold(message.text)),
              style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Turns the model's `**bold**` into real bold, so the reply shows emphasis
/// instead of literal asterisks.
///
/// Bold is the only formatting kept: the server asks the model not to use
/// headings, bullet symbols or tables, which a chat bubble cannot render.
/// A `**` left unpaired (a reply cut short, or a stray marker) is dropped
/// rather than turning everything after it bold.
List<TextSpan> _withBold(String text) {
  final parts = text.split('**');
  final unpaired = parts.length.isEven;
  return [
    for (int i = 0; i < parts.length; i++)
      if (parts[i].isNotEmpty)
        TextSpan(
          text: parts[i],
          style: i.isOdd && !(unpaired && i == parts.length - 1) ? const TextStyle(fontWeight: FontWeight.w600) : null,
        ),
  ];
}
