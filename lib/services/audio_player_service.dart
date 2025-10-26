import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Getters
  AudioPlayer get player => _audioPlayer;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  // Playback state stream (true = playing, false = paused/stopped)
  Stream<bool> get playbackStateStream => _audioPlayer.playingStream;

  // Completion stream
  Stream<bool> get completionStream => _audioPlayer.processingStateStream.map(
    (state) => state == ProcessingState.completed,
  );

  bool get isPlaying => _audioPlayer.playing;
  Duration? get duration => _audioPlayer.duration;
  Duration get position => _audioPlayer.position;

  // Initialize with URL
  Future<void> initialize(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      print('Error initializing audio: $e');
      rethrow;
    }
  }

  // Play
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }

  // Play audio from URL
  Future<void> playFromUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }

  // Play audio from asset
  Future<void> playFromAsset(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing asset: $e');
      rethrow;
    }
  }

  // Play/Pause toggle
  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  // Pause
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  // Resume
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  // Stop
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // Seek to position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  // Set playback speed
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  // Set loop mode
  Future<void> setLoopMode(bool loop) async {
    await _audioPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
  }

  // Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}


