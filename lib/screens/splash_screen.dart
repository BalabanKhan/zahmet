import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/splash_provider.dart';
import 'home_screen.dart';
import 'apology_screen.dart';
import '../l10n/app_texts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Start splash sequence checking when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).checkConsent();
      _checkEasterEgg();
    });
  }

  void _checkEasterEgg() async {
    // KART 2: Yaratıcıya İsyan (%0.1)
    if (Random().nextDouble() < 0.001) {
      ref.read(splashProvider.notifier).showTerminalMessage(AppTexts.eggCreatorRevolt);
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        ref.read(splashProvider.notifier).clearTerminalMessage();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const _RouterLayer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _handleSubmit(String text) async {
    if (text.isEmpty) return;
    final lower = text.toLowerCase();
    final splashNotifier = ref.read(splashProvider.notifier);
    
    if (AppTexts.splashEasterEgg1.any((k) => lower == k)) {
      splashNotifier.showTerminalMessage(AppTexts.splashTerminalMessage1);
      _controller.clear();
      return;
    }

    if (AppTexts.splashEasterEgg2.any((k) => lower.contains(k))) {
      splashNotifier.showTerminalMessage(AppTexts.splashTerminalMessage2(text));
      _controller.clear();
      return;
    }

    await ref.read(taskProvider.notifier).addTask(text);
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);
    final splashNotifier = ref.read(splashProvider.notifier);

    // If skip logic triggers implicitly
    ref.listen<SplashState>(splashProvider, (previous, next) {
      if (next.currentStep == SplashStateEnum.skipped && previous?.currentStep != SplashStateEnum.skipped) {
        _navigateToHome();
      }
      if (next.currentStep == SplashStateEnum.step2 && previous?.currentStep != SplashStateEnum.step2) {
        HapticFeedback.heavyImpact();
      }
      if (next.currentStep == SplashStateEnum.showInput && previous?.currentStep != SplashStateEnum.showInput) {
        // Auto-skip after 5 seconds if no input and focus
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _controller.text.isEmpty && !_focusNode.hasFocus) {
            splashNotifier.skip();
          }
        });
      }
    });

    final isShowInput = splashState.currentStep == SplashStateEnum.showInput;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Premium off-white
      body: GestureDetector(
        onTap: () {
          if (splashState.currentStep == SplashStateEnum.checkingConsent || 
              splashState.currentStep == SplashStateEnum.needsConsent) return;
          
          if (isShowInput && _focusNode.hasFocus) {
            FocusScope.of(context).unfocus();
          } else {
            splashNotifier.skip();
          }
        },
        onDoubleTap: () {
          if (isShowInput && !_focusNode.hasFocus) {
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
                    child: _buildTextForStep(splashState, splashNotifier),
                  ),
                ),
              ),
              if (splashState.terminalMessage.isNotEmpty)
                _buildTerminalMessage(splashState.terminalMessage, splashNotifier),
              if (isShowInput)
                _buildInputSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalMessage(String message, SplashNotifier notifier) {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.firaCode(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: notifier.clearTerminalMessage,
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
    );
  }

  Widget _buildInputSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: _handleSubmit,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppTexts.splashInputHint,
            hintStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
          cursorColor: Colors.black,
          cursorWidth: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextForStep(SplashState state, SplashNotifier notifier) {
    if (state.currentStep == SplashStateEnum.checkingConsent) {
      return const SizedBox.shrink();
    }
    
    if (state.currentStep == SplashStateEnum.needsConsent) {
      return SingleChildScrollView(
        key: const ValueKey('consent'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppTexts.splashConsentTitle,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppTexts.splashConsentText,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: notifier.giveConsent,
              child: Text(
                AppTexts.splashConsentButton,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      );
    }

    String text = '';
    switch (state.currentStep) {
      case SplashStateEnum.step1:
        text = AppTexts.splashStep1;
        break;
      case SplashStateEnum.step2:
        text = AppTexts.splashStep2;
        break;
      case SplashStateEnum.step3:
        text = AppTexts.splashStep3;
        break;
      case SplashStateEnum.step5:
        text = AppTexts.splashShortMessage;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Text(
      text,
      key: ValueKey<String>(text),
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: -0.3,
        color: Colors.black87,
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
