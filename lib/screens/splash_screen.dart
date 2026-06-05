import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import 'home_screen.dart';
import 'apology_screen.dart';
import '../l10n/app_texts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int _step = -2;
  bool _showInput = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _terminalMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  void _checkConsent() async {
    const storage = FlutterSecureStorage();
    final consented = await storage.read(key: 'hasConsented');
    if (consented == 'true') {
      _startSequence();
    } else {
      if (!mounted) return;
      setState(() => _step = -1);
    }
  }

  void _startSequence() async {
    if (!mounted) return;
    setState(() => _step = 0);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _step = 1);
    
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    setState(() => _step = 2);

    HapticFeedback.heavyImpact();
    
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    setState(() => _step = 3);

    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() => _step = 4);

    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    setState(() => _showInput = true);
  }

  void _handleSubmit(String text) async {
    if (text.isEmpty) return;

    final lower = text.toLowerCase();
    
    if (AppTexts.splashEasterEgg1.any((k) => lower == k)) {
      setState(() {
        _terminalMessage = AppTexts.splashTerminalMessage1;
      });
      _controller.clear();
      return;
    }

    if (AppTexts.splashEasterEgg2.any((k) => lower.contains(k))) {
      setState(() {
        _terminalMessage = AppTexts.splashTerminalMessage2(text);
      });
      _controller.clear();
      return;
    }

    await ref.read(taskProvider.notifier).addTask(text);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const _RouterLayer()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          if (_showInput && _focusNode.hasFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        onDoubleTap: () {
          if (_showInput && !_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: _buildTextForStep(),
                  ),
                ),
              ),
              if (_terminalMessage.isNotEmpty)
                Container(
                  color: Colors.black87,
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _terminalMessage,
                          style: GoogleFonts.firaCode(
                            color: Colors.greenAccent,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _terminalMessage = '';
                            });
                          },
                          child: Text(
                            AppTexts.splashTerminalMessageTap,
                            style: GoogleFonts.firaCode(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (_showInput)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onSubmitted: _handleSubmit,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w200, fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppTexts.splashInputHint,
                        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w100, color: Colors.grey),
                      ),
                      cursorColor: Colors.black,
                      cursorWidth: 1,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextForStep() {
    if (_step == -2) return const SizedBox.shrink();
    if (_step == -1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        key: const ValueKey(-1),
        children: [
          Text(AppTexts.splashConsentTitle, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent)),
          const SizedBox(height: 20),
          Text(AppTexts.splashConsentText, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: Colors.black87)),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              const storage = FlutterSecureStorage();
              await storage.write(key: 'hasConsented', value: 'true');
              _startSequence();
            },
            child: Text(AppTexts.splashConsentButton, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          )
        ],
      );
    }

    String text = '';
    switch (_step) {
      case 0:
        return const SizedBox.shrink();
      case 1:
        text = AppTexts.splashStep1;
        break;
      case 2:
        text = AppTexts.splashStep2;
        break;
      case 3:
        text = AppTexts.splashStep3;
        break;
      case 4:
        text = AppTexts.splashStep4;
        break;
    }

    return Text(
      text,
      key: ValueKey<int>(_step),
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w200,
        fontSize: 16,
        color: Colors.black,
        height: 1.5,
      ),
    );
  }
}

class _RouterLayer extends ConsumerWidget {
  const _RouterLayer();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripProvider.select((s) {
      if (s >= 95) return TripState.locked;
      if (s >= 70) return TripState.aestheticTorture;
      if (s >= 30) return TripState.passiveAggressive;
      return TripState.normal;
    }));
    
    if (tripState == TripState.locked) {
      return const ApologyScreen();
    }
    return const HomeScreen();
  }
}
