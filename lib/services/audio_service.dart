import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as session;

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSigh() async {
    try {
      if (!kIsWeb) {
        final s = await session.AudioSession.instance;
        await s.configure(const session.AudioSessionConfiguration(
          avAudioSessionCategory: session.AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions: session.AVAudioSessionCategoryOptions.mixWithOthers,
          avAudioSessionMode: session.AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy: session.AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: session.AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: session.AndroidAudioAttributes(
            contentType: session.AndroidAudioContentType.sonification,
            flags: session.AndroidAudioFlags.audibilityEnforced,
            usage: session.AndroidAudioUsage.alarm,
          ),
          androidAudioFocusGainType: session.AndroidAudioFocusGainType.gainTransientMayDuck,
          androidWillPauseWhenDucked: true,
        ));
      }
      
      await _player.play(AssetSource('audio/sigh.mp3'));
    } catch (e) {
      // Ignore
    }
  }
}
