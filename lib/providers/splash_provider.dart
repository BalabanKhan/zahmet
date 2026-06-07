import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

enum SplashStateEnum {
  checkingConsent,
  needsConsent,
  step0,
  step1,
  breathing,
  step2,
  step3,
  step5,
  showInput,
  skipped,
}

class SplashState {
  final SplashStateEnum currentStep;
  final String terminalMessage;
  
  const SplashState({
    required this.currentStep,
    this.terminalMessage = '',
  });

  SplashState copyWith({
    SplashStateEnum? currentStep,
    String? terminalMessage,
  }) {
    return SplashState(
      currentStep: currentStep ?? this.currentStep,
      terminalMessage: terminalMessage ?? this.terminalMessage,
    );
  }
}

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState(currentStep: SplashStateEnum.checkingConsent));

  bool get isSkipped => state.currentStep == SplashStateEnum.skipped;

  void checkConsent() async {
    final consented = await StorageService.read('hasConsented_v2');
    if (consented == 'true') {
      final seenIntro = await StorageService.read('seenIntro');
      if (seenIntro == 'true') {
        _startShortSequence();
      } else {
        _startSequence();
      }
    } else {
      state = state.copyWith(currentStep: SplashStateEnum.needsConsent);
    }
  }

  void giveConsent() async {
    await StorageService.write('hasConsented_v2', 'true');
    _startSequence();
  }

  void showTerminalMessage(String message) {
    state = state.copyWith(terminalMessage: message);
  }

  void clearTerminalMessage() {
    state = state.copyWith(terminalMessage: '');
  }

  void skip() {
    if (state.currentStep != SplashStateEnum.checkingConsent && state.currentStep != SplashStateEnum.needsConsent) {
      state = state.copyWith(currentStep: SplashStateEnum.skipped);
    }
  }

  Future<void> _startSequence() async {
    await StorageService.write('seenIntro', 'true');
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step0);
    await Future.delayed(const Duration(seconds: 1));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step1);
    await Future.delayed(const Duration(milliseconds: 2500));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.breathing);
    await Future.delayed(const Duration(milliseconds: 600));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step2);
    await Future.delayed(const Duration(seconds: 3));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step3);
    await Future.delayed(const Duration(seconds: 3));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.showInput);
  }

  Future<void> _startShortSequence() async {
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step0);
    await Future.delayed(const Duration(milliseconds: 500));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.step5);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (isSkipped) return;
    state = state.copyWith(currentStep: SplashStateEnum.showInput);
  }
}

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier();
});
