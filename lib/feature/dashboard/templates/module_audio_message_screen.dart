import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';
import 'package:futureme/shared/widgets/video_lesson_card.dart';

/// Shared layout for Module 5's "Audio Message" (472:2292) and "Guided
/// Audio" (495:2170) screens — a module intro followed by a single audio
/// message card, identical in both frames apart from copy. The card actually
/// speaks [messageTitle] + [messageSubtitle] aloud via on-device
/// text-to-speech (see [TtsAudioCard]), unless [videoAssetPath] is given —
/// then the screen plays a recorded clip through [VideoLessonCard] instead.
class ModuleAudioMessageScreen extends StatelessWidget {
  const ModuleAudioMessageScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.messageTitle,
    required this.messageSubtitle,
    required this.continueLabel,
    required this.onContinue,
    this.infoNote,
    this.videoAssetPath,
    this.videoDuration = "1 min",
    this.audioAssetPath,
  });

  /// A recorded audio clip (e.g. `assets/audio/module5_guided.m4a`) played
  /// by the audio card instead of text-to-speech.
  final String? audioAssetPath;

  final String moduleLabel;
  final String title;
  final String description;
  final String messageTitle;
  final String messageSubtitle;

  /// Omitted on the "Audio Message" frame (472:2292) — only "Guided Audio"
  /// (495:2170) shows this note.
  final String? infoNote;
  final String continueLabel;
  final VoidCallback onContinue;

  /// When set, the screen shows this recorded clip (e.g.
  /// `assets/videos/final.mp4`) in a [VideoLessonCard] instead of the
  /// text-to-speech card. The card shows [messageTitle] and
  /// [videoDuration] under the player, so [messageSubtitle] is only used
  /// on the text-to-speech variant.
  final String? videoAssetPath;

  /// Duration label shown on the video card; ignored without
  /// [videoAssetPath].
  final String videoDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moduleLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (videoAssetPath != null)
                      VideoLessonCard(
                        title: messageTitle,
                        duration: videoDuration,
                        assetPath: videoAssetPath!,
                      )
                    else
                      TtsAudioCard(
                        title: messageTitle,
                        subtitle: messageSubtitle,
                        spokenText: "$messageTitle. $messageSubtitle",
                        assetPath: audioAssetPath,
                      ),
                    if (infoNote != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.statusInfoBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              size: 12,
                              color: AppColors.statusInfoFg,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              infoNote!,
                              style: const TextStyle(
                                color: AppColors.statusInfoFg,
                                fontSize: 14,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: continueLabel,
                onpressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
