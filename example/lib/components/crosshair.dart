import 'dart:ui';

import 'package:example/playground_game.dart';
import 'package:flame/components.dart';

class Crosshair extends Component with HasGameRef<PlaygroundGame> {
  List<(Offset, Offset)> _lines = [];
  Offset _center = Offset.zero;

  bool visible = true;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final halfSize = size / 2;
    _center = halfSize.toOffset();
    _lines = [
      (
        (halfSize - Vector2(0, _radius)).toOffset(),
        (halfSize + Vector2(0, _radius)).toOffset()
      ),
      (
        (halfSize - Vector2(_radius, 0)).toOffset(),
        (halfSize + Vector2(_radius, 0)).toOffset()
      ),
    ];
  }

  @override
  void render(Canvas canvas) {
    if (game.menu != null || !visible) {
      return;
    }
    canvas.drawCircle(_center, _radius + 2, _paint1);
    for (final line in _lines) {
      canvas.drawLine(line.$1, line.$2, _paint2);
    }
  }

  void toggle() {
    visible = !visible;
  }

  static const _radius = 10.0;
  static final _paint1 = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final _paint2 = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..strokeWidth = 2;
}
