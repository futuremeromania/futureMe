import 'package:flutter/material.dart';
import 'package:futureme/feature/chat/chat_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';

/// Header pill on the chat screen. The chat is not tied to a module: it sits
/// at the end of the journey and works from the results of all five.
const String chatContextLabel = "Parcursul tău · Modulele 1–5";

/// Opens the FutureMe chat, which talks about the user's combined results
/// from Modules 1-5 and remembers the conversation (see `ChatScreen`).
///
/// It only opens once all five modules are done — before that there is no
/// complete result for the chat to work from — and shows a short note
/// instead. [ignoreCompletionGate] is for the one entry point that is part of
/// finishing Module 5 itself: the final report screen, reached before Module 5
/// is marked complete but only once every module's results exist.
///
/// The greeting and the starter prompts with their first replies are fixed
/// FutureMe copy shown by the app (no model call); everything the user
/// writes after that is answered by `futureme-api`.
void openChat(BuildContext context, {bool ignoreCompletionGate = false}) {
  if (!ignoreCompletionGate && !ModuleProgress.isAllComplete) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Chatul se deschide după ce parcurgi toate cele 5 module.")));
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        contextLabel: chatContextLabel,
        seedMessages: const [
          ChatMessage(
            sender: ChatSender.bot,
            text:
                "Mă bucur că ai ajuns până aici!\nAcum ai rezultatele evaluărilor și raportul tău FutureMe.\nPutem discuta despre ele, despre ce te-a surprins sau despre direcțiile pe care ai vrea să le explorezi.\nImportant este să descoperim împreună ce are sens pentru tine.",
          ),
        ],
        starterPrompts: const [
          StarterPrompt(
            "Aș vrea să înțeleg mai bine o concluzie din raportul meu.",
            "Sigur! Spune-mi exact ce anume nu ți-e clar și discutăm împreună.",
          ),
          StarterPrompt(
            "Ceva din raport m-a surprins sau nu mă reprezintă. Putem discuta despre asta?",
            "Bineînțeles! Spune-mi despre ce este vorba. Aș vrea să înțeleg cum vezi tu lucrurile.",
          ),
          StarterPrompt(
            "Cum îmi dau seama care dintre direcțiile recomandate mi se potrivește mai bine?",
            "Spune-mi între ce direcții oscilezi și ce contează cel mai mult pentru tine. Apoi le vom compara împreună și îți voi arăta cum te pot ajuta rezultatele evaluărilor să faci o alegere.",
          ),
        ],
      ),
    ),
  );
}
