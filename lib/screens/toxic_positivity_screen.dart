import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../l10n/app_texts.dart';

class ToxicPositivityScreen extends StatefulWidget {
  const ToxicPositivityScreen({super.key});

  @override
  State<ToxicPositivityScreen> createState() => _ToxicPositivityScreenState();
}

class _ToxicPositivityScreenState extends State<ToxicPositivityScreen> {
  late ConfettiController _confettiController;
  bool _showSecondPhase = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSecondPhase = true;
        });
      }
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSecondPhase) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              AppTexts.eggToxicPositivity2,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaCode(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.pink, Colors.purple, Colors.yellow, Colors.blue],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                AppTexts.eggToxicPositivity1,
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  color: Colors.pink.shade400,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
