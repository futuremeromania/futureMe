import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCard extends StatelessWidget {
  const VideoPlayerCard(this.controller, {super.key});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    /// The controller is itself a ValueListenable, so rebuilding from it keeps
    /// the overlay in sync with playback — a plain StatelessWidget left the
    /// icon frozen on "play" after tapping it.
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: () {
            value.isPlaying ? controller.pause() : controller.play();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFFE9DCD7),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: AspectRatio(
                          aspectRatio: value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      )
                    : const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
              /// The control only shows while paused: tapping the frame is what
              /// resumes playback, so leaving a button sitting over the picture
              /// would just obscure it.
              if (value.isInitialized)
                AnimatedOpacity(
                  opacity: value.isPlaying ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color(0x73000000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}