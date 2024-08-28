import 'package:flame_3d/core.dart';

extension Vector3Utils on Vector3 {
  static Vector3 lerp(Vector3 a, Vector3 b, double t) {
    return a + (b - a).scaled(t);
  }
}
