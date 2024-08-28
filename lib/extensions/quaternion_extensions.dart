import 'dart:math';

import 'package:flame_3d/core.dart';

extension QuaternionUtils on Quaternion {
  double dot(Quaternion other) {
    return x * other.x + y * other.y + z * other.z + w * other.w;
  }

  static Quaternion slerp(
    Quaternion q0,
    Quaternion q1,
    double t, {
    double epsilon = 10e-3,
  }) {
    if (isEqual(q0, q1)) {
      return q0;
    }

    final dot = q0.dot(q1).clamp(-1, 1);
    final angle = acos(dot);

    if (angle.abs() < epsilon) {
      // The quaternions are very close, so linear interpolation is fine
      return lerp(q0, q1, t);
    }

    final a = sin((1 - t) * angle) / sin(angle);
    final b = sin(t * angle) / sin(angle);

    return q0.scaled(a) + q1.scaled(b);
  }

  static Quaternion lerp(Quaternion q0, Quaternion q1, double t) {
    return q0.scaled(1.0 - t) + q1.scaled(t);
  }

  static bool isEqual(Quaternion a, Quaternion b) {
    return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;
  }
}
