import 'package:audioplayers/audioplayers.dart';

class AmbientAudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  bool _isPlaying = false;

  final Map<String, String> _ambientSounds = {
    'rain': 'assets/audio/ambient/rain.mp3',
    'ocean': 'assets/audio/ambient/ocean.mp3',
    'forest': 'assets/audio/ambient/forest.mp3',
    'fire': 'assets/audio/ambient/fire.mp3',
  };

  Future<void> playAmbient(String type, {double volume = 0.5}) async {
    final soundPath = _ambientSounds[type];
    if (soundPath != null) {
      try {
        await _ambientPlayer.setVolume(volume);
        await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
        await _ambientPlayer.play(AssetSource(soundPath.replaceFirst('assets/', '')));
        _isPlaying = true;
      } catch (e) {
        print('Ambient audio error: $e');
      }
    }
  }

  Future<void> stopAmbient() async {
    await _ambientPlayer.stop();
    _isPlaying = false;
  }

  Future<void> setVolume(double volume) async {
    await _ambientPlayer.setVolume(volume);
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _ambientPlayer.dispose();
  }
}

