import 'dart:math';

import '../gen/assets.gen.dart';

class BoardLogic {
  final int rows;
  final int cols;
  final List<AssetGenImage> allIcons;
  final int iconVariety;

  late List<List<AssetGenImage?>> board;

  BoardLogic({
    required this.rows,
    required this.cols,
    required this.allIcons,
    required this.iconVariety,
  }) {
    _initBoard();
  }

  /// 初始化棋盘，保证图标成对出现
  void _initBoard() {
    board = List.generate(rows, (_) => List.filled(cols, null));
    final totalTiles = rows * cols - 1; // 中心空格

    // 挑选要用的图标
    final icons = allIcons.take(iconVariety).toList();

    // 生成配对
    final pairs = <AssetGenImage>[];
    for (int i = 0; i < totalTiles ~/ 2; i++) {
      final icon = icons[i % icons.length];
      pairs.add(icon);
      pairs.add(icon);
    }

    // 打乱
    pairs.shuffle(Random());

    // 填入棋盘
    int idx = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (r == rows ~/ 2 && c == cols ~/ 2) continue; // 中间空
        board[r][c] = pairs[idx++];
      }
    }
  }

  AssetGenImage? getTile(int r, int c) => board[r][c];

  void removeTiles(int r1, int c1, int r2, int c2) {
    board[r1][c1] = null;
    board[r2][c2] = null;
  }

  /// 检查两格是否可连接（支持外围 + ≤2拐角）
  bool canConnect(int r1, int c1, int r2, int c2) {
    final a = board[r1][c1];
    final b = board[r2][c2];
    if (a == null || b == null) return false;
    if (!identical(a, b)) return false;
    if (r1 == r2 && c1 == c2) return false;

    // 👉 最后一对直接放行
    if (_remainingTilesCount() == 2) return true;

    return _canConnectBFS(r1, c1, r2, c2);
  }

  /// BFS 判断可连通（≤2拐角，外围也允许）
  bool _canConnectBFS(int r1, int c1, int r2, int c2) {
    final directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
    ];

    // 扩展边界（外围连线：相当于多一圈空格）
    final visited =
    List.generate(rows + 2, (_) => List.filled(cols + 2, 3, growable: false));
    final queue = <List<int>>[];

    queue.add([r1 + 1, c1 + 1, -1, 0]); // r, c, dir, turns
    visited[r1 + 1][c1 + 1] = 0;

    while (queue.isNotEmpty) {
      final cur = queue.removeAt(0);
      final r = cur[0], c = cur[1], dir = cur[2], turns = cur[3];

      for (int i = 0; i < 4; i++) {
        int nr = r, nc = c;
        int newTurns = turns + (dir == -1 || dir == i ? 0 : 1);

        if (newTurns > 2) continue;

        while (true) {
          nr += directions[i][0];
          nc += directions[i][1];
          if (nr < 0 || nc < 0 || nr >= rows + 2 || nc >= cols + 2) break;

          // 转换回棋盘坐标
          int br = nr - 1, bc = nc - 1;

          if (br == r2 && bc == c2) return true;

          // 空格才能继续走
          if (br >= 0 &&
              bc >= 0 &&
              br < rows &&
              bc < cols &&
              board[br][bc] != null) break;

          if (visited[nr][nc] > newTurns) {
            visited[nr][nc] = newTurns;
            queue.add([nr, nc, i, newTurns]);
          }
        }
      }
    }

    return false;
  }

  /// 是否还有可消除的对
  bool hasMoves() {
    final cells = <List<int>>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c] != null) cells.add([r, c]);
      }
    }

    // 👉 最后一对直接认为有招
    if (cells.length == 2) {
      final a = cells[0], b = cells[1];
      return identical(board[a[0]][a[1]], board[b[0]][b[1]]);
    }

    // 扫描所有配对
    for (int i = 0; i < cells.length; i++) {
      for (int j = i + 1; j < cells.length; j++) {
        final a = cells[i], b = cells[j];
        if (identical(board[a[0]][a[1]], board[b[0]][b[1]]) &&
            canConnect(a[0], a[1], b[0], b[1])) {
          return true;
        }
      }
    }
    return false;
  }

  /// 统计剩余非空格子
  int _remainingTilesCount() {
    int cnt = 0;
    for (var row in board) {
      for (var t in row) {
        if (t != null) cnt++;
      }
    }
    return cnt;
  }

  /// 重排剩余图标，避免死局
  void reshuffle() {
    if (_remainingTilesCount() <= 2) return; // 剩最后两格不需要打乱

    final tiles = <AssetGenImage>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c] != null) {
          tiles.add(board[r][c]!);
        }
      }
    }

    bool hasMovesAfterShuffle = false;
    final rng = Random();
    while (!hasMovesAfterShuffle) {
      tiles.shuffle(rng);
      int idx = 0;
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          if (board[r][c] != null) {
            board[r][c] = tiles[idx++];
          }
        }
      }
      hasMovesAfterShuffle = this.hasMoves();
    }
  }
}