import 'dart:ui';

import 'package:flame/components.dart' show Component;
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/components/line_3d.dart';

class GridLines extends Component {
  static const _gridSize = 2.0;
  bool visible = true;

  @override
  Future<void> onLoad() async {
    await addAll([
      Line3D.generate(
        start: Vector3(-_gridSize, 0, 0),
        end: Vector3(_gridSize, 0, 0),
        color: const Color(0xFFFF0000),
      ),
      Line3D.generate(
        start: Vector3(0, -_gridSize, 0),
        end: Vector3(0, _gridSize, 0),
        color: const Color(0xFF00FF00),
      ),
      Line3D.generate(
        start: Vector3(0, 0, -_gridSize),
        end: Vector3(0, 0, _gridSize),
        color: const Color(0xFF0000FF),
      ),
    ]);
  }

  void toggle() {
    visible = !visible;
  }

  @override
  void renderTree(Canvas canvas) {
    if (!visible) {
      return;
    }
    super.renderTree(canvas);
  }
}
