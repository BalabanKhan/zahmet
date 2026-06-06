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
              child: Stack(
                children: [
                  // İstatistikler (Merkezde)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRow("${AppTexts.recordCompleted}: ", "${stats.completedTasks}"),
                          const SizedBox(height: 16),
                          _buildStatRow("${AppTexts.recordPostponed}: ", "${stats.postponedTasks}"),
                          const SizedBox(height: 16),
                          _buildStatRow("${AppTexts.recordTripLevel}: ", "%$tripLevel ($tripStateName)"),
                          const SizedBox(height: 16),
                          _buildStatRow("${AppTexts.recordCharacterScore}: ", "$characterScore / 100 ${AppTexts.recordScoreTitle(characterScore)}"),
                        ],
                      ),
                    ),
                  ),
                  
                  // Alt kısımdaki gizli butonlar
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
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
                                        style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
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
                                style: GoogleFonts.roboto(
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
                                style: GoogleFonts.roboto(
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
                                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xFF9E9E9E), fontSize: 12),
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
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Colors.black26,
                                  ),
                                ),
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

  Widget _buildStatRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.roboto(fontSize: 14, color: Colors.black54),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.w400)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        ],
      ),
    );
  }
}
