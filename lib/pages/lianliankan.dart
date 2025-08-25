import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/sound_manager.dart';

import '../gen/assets.gen.dart';
import '../logic/board_logic.dart';
import '../utils/game_timer.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late BoardLogic logic;
  int? selectedR;
  int? selectedC;

  bool _isMuted = false; // 静音状态

  late AnimationController _hintController;
  late Animation<double> _hintAnimation;
  List<Point<int>> hintPoints = []; // 保存闪烁的两格坐标

  final GameTimer gameTimer = GameTimer(); // 计时器

  @override
  void dispose() {
    SoundManager().dispose();
    _hintController.dispose();
    gameTimer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initLogic();
    gameTimer.loadBestRecord(); // 初始化时加载历史纪录
    gameTimer.start(); // 游戏开始时启动计时器

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // 循环闪烁

    _hintAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      SoundManager().isMuted = _isMuted; // 同步到 SoundManager
    });
  }

  void _initLogic() {
    logic = BoardLogic(
      rows: 9,
      cols: 17,
      allIcons: Assets.icons.values,
      iconVariety: Assets.icons.values.length,
    );
  }

  void _onTileTap(int r, int c) {
    final tile = logic.getTile(r, c);
    if (tile == null) return;
    SoundManager().playClick();

    if (selectedR == null || selectedC == null) {
      setState(() {
        selectedR = r;
        selectedC = c;
      });
    } else {
      final sr = selectedR!, sc = selectedC!;
      if (sr == r && sc == c) {
        setState(() {
          selectedR = null;
          selectedC = null;
        });
        return;
      }

      if (logic.canConnect(sr, sc, r, c)) {
        _removeWithAnimation(sr, sc, r, c);
      } else {
        setState(() {
          selectedR = r;
          selectedC = c;
        });
      }
    }
  }

  Future<void> _removeWithAnimation(int r1, int c1, int r2, int c2) async {
    setState(() {
      selectedR = null;
      selectedC = null;
    });

    // 播放音效
    SoundManager().playRemove();

    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        logic.removeTiles(r1, c1, r2, c2);

        if (!logic.hasMoves()) {
          logic.reshuffle();
        }

        if (_isBoardEmpty()) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _showWinDialog();
          });
        }
      });
    });
  }

  bool _isBoardEmpty() {
    for (var row in logic.board) {
      for (var t in row) {
        if (t != null) return false;
      }
    }
    return true;
  }

  Future<void> _showWinDialog() async {

    Duration timeUsed = await gameTimer.stop();

    String resultMsg = "你消除了所有图标！\n本次用时: ${timeUsed.inSeconds} 秒";
    if (gameTimer.bestRecord != null) {
      resultMsg += "\n最快纪录: ${gameTimer.bestRecord!.inSeconds} 秒";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('恭喜！'),
        content: Text(resultMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initLogic();
              });
              gameTimer.reset(); // 重置计时器
              gameTimer.start(); // 重新开始计时
            },
            child: const Text('再来一局'),
          )
        ],
      ),
    );
  }

  void showHint() {
    hintPoints.clear();
    final cells = <Point<int>>[];
    for (int r = 0; r < logic.rows; r++) {
      for (int c = 0; c < logic.cols; c++) {
        if (logic.getTile(r, c) != null) {
          cells.add(Point(r, c));
        }
      }
    }

    for (int i = 0; i < cells.length; i++) {
      for (int j = i + 1; j < cells.length; j++) {
        final a = cells[i];
        final b = cells[j];
        if (logic.getTile(a.x, a.y) == logic.getTile(b.x, b.y) &&
            logic.canConnect(a.x, a.y, b.x, b.y)) {
          hintPoints = [a, b];

          setState(() {}); // 立即刷新 UI

          // 自动取消高亮 2 秒后
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              hintPoints.clear();
            });
          });
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const margin = 4.0; // 格子间距
    const maxCellSize = 50.0; // 最大格子大小

    // 根据屏幕宽高自动计算缩放系数，保证棋盘完整显示
    final scaleX = (screenWidth - (logic.cols + 1) * margin) / (logic.cols * maxCellSize);
    final scaleY = (screenHeight - 100 - (logic.rows + 1) * margin) / (logic.rows * maxCellSize); // 100 为 AppBar+padding
    final scale = min(scaleX, scaleY).clamp(0.5, 1.0); // 最小缩放0.5

    final cellSize = maxCellSize * scale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('连连看'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AnimatedBuilder(
                animation: gameTimer,
                builder: (_, __) {
                  final best = gameTimer.bestRecord != null
                      ? '${gameTimer.bestRecord!.inSeconds}s'
                      : '--';
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('用时: ${gameTimer.formatDuration(gameTimer.elapsed)}',
                          style: const TextStyle(fontSize: 14)),
                      Text('最快: $best', style: const TextStyle(fontSize: 14)),
                    ],
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: _toggleMute,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                logic.reshuffle();
                selectedR = null;
                selectedC = null;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: showHint,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(logic.rows, (r) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(logic.cols, (c) {
                final tile = logic.getTile(r, c);
                bool isHinted = hintPoints.any((p) => p.x == r && p.y == c);
                return GestureDetector(
                  onTap: () => _onTileTap(r, c),
                  child: AnimatedScale(
                    scale: tile == null ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      margin: const EdgeInsets.all(margin / 2),
                      decoration: BoxDecoration(
                        color: tile == null ? Colors.transparent : Colors.blue[50],
                        border: (tile == null)
                            ? null
                            : Border.all(
                          color: (selectedR == r && selectedC == c)
                              ? Colors.red
                              : (isHinted ? Colors.yellow.withAlpha((_hintAnimation.value * 255).toInt()) : Colors.transparent),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isHinted
                            ? [
                          BoxShadow(
                            color: Colors.yellow.withAlpha((_hintAnimation.value * 100).toInt()),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                            : null,
                      ),
                      child: tile == null
                          ? null
                          : Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: tile.image(fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}