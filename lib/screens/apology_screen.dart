import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/trip_provider.dart';
import '../l10n/app_texts.dart';

class ApologyScreen extends ConsumerStatefulWidget {
  const ApologyScreen({super.key});

  @override
  ConsumerState<ApologyScreen> createState() => _ApologyScreenState();
}

class _ApologyScreenState extends ConsumerState<ApologyScreen> {
  final TextEditingController _controller = TextEditingController();
  final String _expectedText = AppTexts.apologyExpectedText;

  int _clearCount = 0;
  int _failCount = 0;

  void _onChanged(String text) {
    if (text.isEmpty) return;

    if (!_expectedText.startsWith(text)) {
      if (_clearCount < 2) {
        _controller.clear();
        _clearCount++;
      }
      setState(() {
        _failCount++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTexts.apologyFail,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (text == _expectedText) {
      ref.read(tripProvider.notifier).resetScore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // Cancel option removed
              Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTexts.apologyPride,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppTexts.apologyInstruct,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _expectedText,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: AppTexts.apologyStartOver,
                      hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                  ),
                  if (_failCount >= 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: GestureDetector(
                        onTap: () {
                          ref.read(tripProvider.notifier).resetScore();
                        },
                        child: Text(
                          AppTexts.isTr ? "bir cümleyi bile yazmayı beceremedim, geç" : "i couldn't even type one sentence, pass",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.redAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
