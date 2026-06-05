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
  bool _isProcessingBribe = false;

  void _onChanged(String text) {
    if (text.isEmpty) return;

    if (!_expectedText.startsWith(text)) {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTexts.apologyFail,
            style: GoogleFonts.inter(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (text == _expectedText) {
      ref.read(tripProvider.notifier).resetScore();
    }
  }

  void _bribe() async {
    setState(() {
      _isProcessingBribe = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessingBribe = false;
    });

    ref.read(tripProvider.notifier).resetScore();
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
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // İsterse ekstra easter egg eklenebilir
                },
                child: Padding(
                  padding: const EdgeInsets.all(40.0), // UX Fix: Devasa tıklama alanı
                  child: Text(
                    'peki.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w100,
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTexts.apologyPride,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w200,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppTexts.apologyInstruct,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w100,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _expectedText,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w200, fontSize: 16),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: AppTexts.apologyStartOver,
                      hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w100, color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                  ),
                  const SizedBox(height: 60),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 24),
                  Text(
                    AppTexts.apologyOr,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w100,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isProcessingBribe)
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppTexts.apologyBribeWait,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w100, fontSize: 10),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _bribe,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          AppTexts.apologyBribe,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
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
    );
  }
}
