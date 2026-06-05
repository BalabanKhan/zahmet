import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../l10n/app_texts.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Geri butonu
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back, color: Color(0xFFBDBDBD), size: 28),
                ),
              ),
            ),
            
            // Alt kısımdaki butonlar
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppTexts.privacyMessage,
                              style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12),
                            ),
                            backgroundColor: Colors.black87,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          AppTexts.privacyPolicy,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: const Color(0xFFBDBDBD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        ref.read(taskProvider.notifier).clearAllTasks();
                        ref.read(tripProvider.notifier).resetScore();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppTexts.deleteMessage,
                              style: GoogleFonts.roboto(fontWeight: FontWeight.w300, color: const Color(0xFFBDBDBD), fontSize: 12),
                            ),
                            backgroundColor: Colors.black87,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          AppTexts.deleteData,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: const Color(0xFFBDBDBD),
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
    );
  }
}
