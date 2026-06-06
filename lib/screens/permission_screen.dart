import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_provider.dart';
import '../l10n/app_texts.dart';

class PermissionScreen extends ConsumerWidget {
  final Permission permission;
  final String threatMessage;
  final VoidCallback onGranted;

  const PermissionScreen({
    super.key,
    required this.permission,
    required this.threatMessage,
    required this.onGranted,
  });

  Future<void> _requestPermission(BuildContext context, WidgetRef ref) async {
    final status = await permission.request();
    
    if (status.isGranted) {
      if (context.mounted) {
        Navigator.of(context).pop();
        onGranted();
      }
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppTexts.permissionPermanentlyDenied,
              style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12),
            ),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 4),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        openAppSettings();
      }
    } else {
      if (context.mounted) {
        ref.read(tripProvider.notifier).increaseScore(50);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppTexts.permissionDenied,
              style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12),
            ),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                threatMessage,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: () => _requestPermission(context, ref),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    AppTexts.permissionShowPrompt,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  ref.read(tripProvider.notifier).increaseScore(50);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.black,
                  child: Text(
                    AppTexts.permissionAfraid,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
