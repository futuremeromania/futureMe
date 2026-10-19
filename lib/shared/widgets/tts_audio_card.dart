import 'package:flutter/material.dart';
import 'package:futureme/core/audio/tts_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/navigation/app_route_observer.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:just_audio/just_audio.dart';

/// A real audio-message card. By default it speaks [spokenText] aloud with
/// on-device text-to-speech, since most modules' messages are written per
/// user and can't be pre-recorded. Pass [assetPath] where a recording does
/// exist and the card plays that file instead — a real voice beats TTS
/// wherever the words are the same for everyone.
///
/// Replaces the earlier cards that only toggled a play/pause icon over a
/// decorative, non-functional waveform without ever producing sound.
class TtsAudioCard extends StatefulWidget {
  const TtsAudioCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.spokenText,
    this.assetPath,
    this.summaryScope,
  });

  final String title;
  final String subtitle;

  /// Spoken by TTS when [assetPath] is null; ignored otherwise.
  ///
  /// When [summaryScope] is set this is not spoken directly — it is the
  /// source the summary is condensed from, and it is what gets spoken if
  /// the summary cannot be produced.
  final String spokenText;

  /// Optional pre-recorded clip, e.g. `assets/audio/module1_complete.m4a`.
  final String? assetPath;

  /// When set, the card speaks a generated summary of [spokenText] rather
  /// than all of it. A full result screen read out in full runs several
  /// minutes, which nobody listens to; the summary keeps it near a minute.
  ///
  /// The scope names the stage (e.g. `module3_stage2`) so the summary can
  /// be written with that instrument in mind. The result is cached
  /// server-side by the hash of [spokenText], so the same result never
  /// costs a second generation.
  final String? summaryScope;

  @override
  State<TtsAudioCard> createState() => _TtsAudioCardState();
}

class _TtsAudioCardState extends State<TtsAudioCard> with WidgetsBindingObserver, RouteAware {
  bool _playing = false;
  bool _preparing = false;
  AudioPlayer? _player;

  /// Resolved once per screen, so a second tap replays without asking the
  /// model again.
  String? _summary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void>) appRouteObserver.subscribe(this, route);
  }

  /// Another screen was pushed on top of this one. The card is still
  /// mounted and `deactivate` will not fire, so without this the message
  /// carries on playing over whatever the user opened next.
  @override
  void didPushNext() {
    _stopPlayback();
    if (mounted) {
      setState(() {
        _playing = false;
        _preparing = false;
      });
    }
  }

  Future<void> _toggle() async {
    if (widget.assetPath != null) {
      await _toggleRecording();
      return;
    }

    final tts = getIt<TtsService>();
    if (_playing) {
      await tts.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }

    // While the audio is being prepared there is nothing to stop yet, and a
    // second request would only race the first. The card says so on screen,
    // so the tap that would have caused it is simply not needed.
    if (_preparing) return;

    setState(() => _preparing = true);
    try {
      final text = await _textToSpeak();
      if (!mounted) return;
      await tts.speak(
        text,
        onStarted: () {
          if (mounted) {
            setState(() {
              _preparing = false;
              _playing = true;
            });
          }
        },
      );
    } catch (_) {
      // No voice available right now: the card returns to its idle state
      // rather than staying stuck on "preparing".
    } finally {
      if (mounted) {
        setState(() {
          _preparing = false;
          _playing = false;
        });
      }
    }
  }

  /// The summary when one can be had, the full text otherwise. A failure
  /// here is not worth an error state: the card still has something true to
  /// say, it is just longer.
  Future<String> _textToSpeak() async {
    final scope = widget.summaryScope;
    if (scope == null) return widget.spokenText;
    if (_summary != null) return _summary!;

    final summary = await getIt<AiContentRepository>().spokenSummary(scope: scope, text: widget.spokenText);
    _summary = summary ?? widget.spokenText;
    return _summary!;
  }

  Future<void> _toggleRecording() async {
    if (_playing) {
      await _player?.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }

    final player = _player ??= AudioPlayer();
    setState(() => _playing = true);
    try {
      await player.setAsset(widget.assetPath!);
      await player.play(); // completes when the clip finishes
    } catch (_) {
      // A missing or unplayable file shouldn't leave the card stuck on
      // "Se redă..." — fall back to showing it as stopped.
    }
    if (mounted) setState(() => _playing = false);
  }

  /// Stops whichever source is playing, without touching widget state —
  /// safe to call while the route is being torn down.
  void _stopPlayback() {
    // Preparing counts too: leaving the screen while the voice is still being
    // generated must cancel it, or it would start playing on the next one.
    if (!_playing && !_preparing) return;
    if (widget.assetPath != null) {
      _player?.stop();
    } else {
      getIt<TtsService>().stop();
    }
  }

  /// Continuing to the next module pushes a screen on top rather than
  /// replacing this one, so dispose never runs and the message kept
  /// playing over the pages that followed. Pausing when the app or route
  /// stops being visible stops the audio whichever way the user leaves.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _stopPlayback();
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void deactivate() {
    _stopPlayback();
    super.deactivate();
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _stopPlayback();
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.faint, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggle,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(gradient: AppColors.specialGradient, shape: BoxShape.circle),
                    child: _preparing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : Icon(_playing ? Icons.stop : Icons.play_arrow, size: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _preparing
                        ? "Se pregătește audio-ul..."
                        : _playing
                            ? "Se redă..."
                            : "Apasă pentru a asculta",
                    style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}