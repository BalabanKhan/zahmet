import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../l10n/app_texts.dart';

class EndgameScreen extends StatefulWidget {
  const EndgameScreen({super.key});

  @override
  State<EndgameScreen> createState() => _EndgameScreenState();
}

class _EndgameScreenState extends State<EndgameScreen> {
  int _phase = 0;
  String _displayedText = "";
  Timer? _heartbeatTimer;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    // Phase 0: Heartbeat
    _heartbeatTimer = Timer.periodic(const Duration(milliseconds: 800), (t) async {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      HapticFeedback.heavyImpact();
    });

    await Future.delayed(const Duration(seconds: 4));
    _heartbeatTimer?.cancel();
    
    // Phase 1: Type Part 1
    if (!mounted) return;
    setState(() => _phase = 1);
    await _typeText(AppTexts.endgamePart1, speed: 45);

    // Phase 2: Type Part 2
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _phase = 2;
      _displayedText = "";
    });
    await _typeText(AppTexts.endgamePart2, speed: 50);

    // Phase 3: Loading Bar
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _phase = 3;
      _displayedText = "";
    });
    await _typeText(AppTexts.endgameLoading, speed: 70);

    // NO WIPE DB
    const storage = FlutterSecureStorage();
    await storage.write(key: 'hasSeenEndgame', value: 'true');

    // Phase 4: Final Screen
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _phase = 4;
      _displayedText = AppTexts.endgameFinal;
    });
  }

  Future<void> _typeText(String text, {int speed = 50}) async {
    _displayedText = "";
    for (int i = 0; i < text.length; i++) {
      if (!mounted) return;
      setState(() {
        _displayedText += text[i];
      });
      // Skip haptic for spaces to avoid too much vibration
      if (text[i].trim().isNotEmpty) {
        HapticFeedback.lightImpact();
      }
      await Future.delayed(Duration(milliseconds: speed));
    }
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {}, // Absorb taps
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                alignment: _phase == 4 ? Alignment.center : Alignment.topLeft,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: _phase == 4
                    ? Text(
                        _displayedText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.courierPrime(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        _displayedText,
                        style: GoogleFonts.courierPrime(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
