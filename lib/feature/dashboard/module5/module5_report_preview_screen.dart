import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// "Module 5 - Report Preview" (Figma frame 494:2163). Figma annotates the
/// PDF viewer as "use a mobile-friendly viewer with vertical scrolling and
/// zoom" — there's no actual PDF file/renderer here, but when the real
/// AI-generated report is available ([sections] non-null) its text is shown
/// directly instead of the static placeholder card.
class Module5ReportPreviewScreen extends StatelessWidget {
  const Module5ReportPreviewScreen({
    super.key,
    required this.titleLabel,
    required this.primaryLabel,
    required this.onPrimary,
    required this.chatLabel,
    required this.onChat,
    this.onDownload,
    this.onShare,
    this.summary,
    this.sections,
  });

  final String titleLabel;
  final String primaryLabel;
  final String chatLabel;
  final VoidCallback onPrimary;
  final VoidCallback onChat;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  /// The real report content ({title, body} per section), or null while
  /// generation hasn't finished/succeeded yet.
  final String? summary;
  final List<Map<String, String>>? sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    titleLabel,
                    style: const TextStyle(
                      color: AppColors.uiHeadingSmall,
                      fontSize: 16,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w500,
                      height: 1.375,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download_outlined),
                  ),
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.ios_share),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x59CFB2A4),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: sections == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: AppColors.borderStrong,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Raportul tău FutureMe",
                                style: TextStyle(
                                  color: AppColors.uiHeadingSmall,
                                  fontSize: 14,
                                  fontFamily: AppFonts.body,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (summary != null) ...[
                                Text(
                                  summary!,
                                  style: const TextStyle(
                                    color: AppColors.uiHeadingSmall,
                                    fontSize: 14,
                                    fontFamily: AppFonts.body,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              for (final s in sections!) ...[
                                Text(
                                  s['title'] ?? '',
                                  style: const TextStyle(
                                    color: AppColors.uiHeading,
                                    fontSize: 16,
                                    fontFamily: AppFonts.heading,
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s['body'] ?? '',
                                  style: const TextStyle(
                                    color: AppColors.dashboard,
                                    fontSize: 14,
                                    fontFamily: AppFonts.body,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(content: primaryLabel, onpressed: onPrimary),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onChat,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grad1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 24,
                            color: AppColors.grad1,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chatLabel,
                            style: const TextStyle(
                              color: AppColors.grad1,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
