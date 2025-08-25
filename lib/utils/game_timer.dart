import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameTimer extends ChangeNotifier {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration? bestRecord;
  VoidCallback? onTick;

  /// 初始化时加载最快纪录
  Future<void> loadBestRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt('best_record');
    if (seconds != null) {
      bestRecord = Duration(seconds: seconds);
    }
  }

  /// 开始计时
  void start({VoidCallback? tick}) {
    onTick = tick;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners(); // 通知监听者
      if (onTick != null) onTick!();
    });
  }

  /// 停止计时并返回本次用时
  Future<Duration> stop() async {
    _timer?.cancel();
    _timer = null;
    await _saveIfBest();
    final result = _elapsed;
    _elapsed = Duration.zero;
    return result;
  }

  Duration get elapsed => _elapsed;

  /// 保存最快纪录
  Future<void> _saveIfBest() async {
    if (bestRecord == null || _elapsed < bestRecord!) {
      bestRecord = _elapsed;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('best_record', _elapsed.inSeconds);
    }
  }

  /// 重置计时
  void reset() {
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
    notifyListeners();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}