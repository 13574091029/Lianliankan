import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _player = AudioPlayer(); // 单个播放器用于短音效

  bool isMuted = false;

  /// 播放点击音效
  Future<void> playClick() async {
    if (isMuted) return;
    _player.play(AssetSource('sounds/click.mp3'));
  }

  /// 播放消除音效
  Future<void> playRemove() async {
    if (isMuted) return;
    _player.play(AssetSource('sounds/correct.mp3'));
  }

  /// 播放自定义音效
  Future<void> playSound(String fileName) async {
    if (isMuted) return;
    _player.play(AssetSource('sounds/$fileName'));
  }

  /// 静音开关
  void toggleMute() {
    isMuted = !isMuted;
  }

  void dispose() {
    _player.dispose();
  }
}