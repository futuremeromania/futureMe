import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/video_player_screen.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

/// Extracted from the identical video-card block duplicated in
/// video_welcome_screen.dart and function_video.dart.
class VideoLessonCard extends StatelessWidget {
  const VideoLessonCard({
    super.key,
    required this.title,
    required this.assetPath,
    this.duration = "1 min",
  });

  final String title;

  /// Which clip this card plays — every caller passes its own, so the
  /// onboarding intro doesn't end up playing on every screen.
  final String assetPath;

  final String duration;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      contents: [
        VideoApp(assetPath: assetPath),
        const SizedBox(height: 10),
        LeftBoldText(content: title),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.timelapse_rounded,
                color: Color(0xFF6D5D78),
              ),
              Expanded(
                child: LeftLightText(content: duration),
              ),
            ],
          ),
        ),
      ],
    );
  }
}