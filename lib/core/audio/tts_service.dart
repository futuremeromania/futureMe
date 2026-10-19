import 'package:futureme/core/constants/backend.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

/// Speaks module feedback in the app's own cloned voice: the text is sent to
/// the `synthesizeSpeech` callable, which returns a cached MP3 URL that plays
/// here. Replaces the on-device engine, whose robotic delivery undercut the
/// warmth the written feedback is meant to carry.
@lazySingleton
class TtsService {
  final AudioPlayer _player = AudioPlayer();

  /// Decorative characters that belong to the layout, not to speech.
  ///
  /// `eleven_multilingual_v2` infers the language from the text itself (it
  /// takes no language parameter), and a stray `+` or `·` in otherwise
  /// Romanian copy is enough to tip the voice into reading whole words with
  /// English pronunciation. Screens should phrase their spoken text in
  /// words to begin with; this is the safety net for anything that slips
  /// through.
  static String _forSpeech(String text) => text
      .replaceAll('↔', ', ')
      .replaceAll('·', ', ')
      .replaceAll(' + ', ' și ')
      .replaceAll('—', ', ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Bumped by every [speak] and every [stop]. A request that finds it has
  /// moved on by the time its audio is ready has been cancelled or replaced,
  /// and must not play.
  int _generation = 0;

  /// Speaks [text] aloud. [onStarted] fires the moment sound actually
  /// begins — generating the voice takes a few seconds first. Completes once
  /// playback finishes, or once [stop] is called from elsewhere.
  ///
  /// Without the generation check, a request still waiting on the voice
  /// could not be cancelled: a tap that "stopped" it only stopped a player
  /// that was not playing yet, the request then started the sound anyway,
  /// and the next tap restarted the same audio from the top — which is how
  /// the start of a feedback came to be heard twice.
  Future<void> speak(String text, {void Function()? onStarted}) async {
    final generation = ++_generation;

    final result = await appFunctions
        .httpsCallable('synthesizeSpeech')
        .call<Map<String, dynamic>>({'text': _forSpeech(text)});
    if (generation != _generation) return;

    await _player.setUrl(result.data['url'] as String);
    if (generation != _generation) return;

    onStarted?.call();
    await _player.play();
    // Finished, or stopped part-way: either way this request is over.
    await _player.processingStateStream.firstWhere((s) => s == ProcessingState.completed || s == ProcessingState.idle);
    if (generation == _generation) await _player.stop();
  }

  Future<void> stop() {
    _generation++;
    return _player.stop();
  }
}