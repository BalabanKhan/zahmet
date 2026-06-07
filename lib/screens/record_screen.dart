import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/stats_provider.dart';
import '../l10n/app_texts.dart';
import '../widgets/back_triangle.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final tripScore = ref.watch(tripProvider);
    final tripLevel = 100 - tripScore;
    final tripStateName = AppTexts.recordTripStateName(ref.read(tripProvider.notifier).tripState);
    
    // Calculate character score
    int characterScore = 100 + stats.completedTasks - (stats.postponedTasks * 3);
    characterScore = characterScore.clamp(0, 100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24),
                      child: const BackTriangle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWallOfShame(context, ref),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 16),
                    _buildStatRow("${AppTexts.recordCompleted}: ", "${stats.completedTasks}"),
                    const SizedBox(height: 16),
                    _buildStatRow("${AppTexts.recordPostponed}: ", "${stats.postponedTasks}"),
                    const SizedBox(height: 16),
                    _buildStatRow("${AppTexts.recordTripLevel}: ", "%$tripLevel ($tripStateName)"),
                    const SizedBox(height: 16),
                    _buildStatRow("${AppTexts.recordCharacterScore}: ", "$characterScore / 100 ${AppTexts.recordScoreTitle(characterScore)}"),
                    const Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse('https://docs.google.com/document/d/e/2PACX-1vTCK5kiIirw33dAAol_SyvUEQSFVEdpVqCacT2pxDVPEqWq16Efk951s5YN-nj8S4UkpmCPYCc49d5U/pub');
                            if (!await launchUrl(url)) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppTexts.privacyMessage,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
                                    ),
                                    backgroundColor: Colors.black87,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              AppTexts.privacyPolicy,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (stats.resetCount >= 2)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              AppTexts.recordDeleteLimit,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Colors.black26,
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              ref.read(taskProvider.notifier).clearAllTasks();
                              ref.read(tripProvider.notifier).resetScore();
                              ref.read(statsProvider.notifier).incrementResetCount();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppTexts.deleteMessage,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
                                    ),
                                    backgroundColor: Colors.black87,
                                    duration: const Duration(seconds: 4),
                                  ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                AppTexts.deleteData,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallOfShame(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final postponedTasks = tasks.where((t) => t.snoozeCount > 0).toList();
    postponedTasks.sort((a, b) => b.snoozeCount.compareTo(a.snoozeCount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.wallOfShameTitle,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppTexts.wallOfShameSubtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        if (postponedTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppTexts.isTr 
                  ? "Henüz ertelediğin bir yalanın yok. Şaşırtıcı." 
                  : "No postponed lies yet. Surprising.",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black38,
              ),
            ),
          )
        else
          ...postponedTasks.take(5).map((t) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppTexts.wallOfShameTimes(t.snoozeCount),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w400)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        ],
      ),
    );
  }
}
