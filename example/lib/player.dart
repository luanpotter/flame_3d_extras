import 'package:example/key_event_handler.dart';
import 'package:example/mouse.dart';
import 'package:example/playground_game.dart';
import 'package:flame/components.dart' show HasGameReference;
import 'package:flame_3d/components.dart';
import 'package:flame_3d/game.dart';

class Player extends Component3D
    with KeyEventHandler, HasGameReference<PlaygroundGame> {
  Player({
    required super.position,
  });

  @override
  bool get propagateKeyEvent =>
      isAnyDown([Key.keyW, Key.keyS, Key.keyA, Key.keyD, Key.shiftLeft]);

  Vector3 get forward => Vector3(0, 0, 1)..applyQuaternion(rotation);

  @override
  void update(double dt) {
    if (game.isPaused) {
      return;
    }

    final isBoosting = isKeyDown(Key.shiftLeft) && isKeyDown(Key.keyW);

    final multiplier = isBoosting ? 8 : 1;
    if (isKeyDown(Key.keyW)) {
      accelerate(moveSpeed * multiplier * dt);
    } else if (isKeyDown(Key.keyS)) {
      accelerate(-moveSpeed * dt);
    }
    if (isKeyDown(Key.keyA)) {
      strafe(-strafingSpeed * dt);
    } else if (isKeyDown(Key.keyD)) {
      strafe(strafingSpeed * dt);
    }

    final mouseDelta = Mouse.getDelta();
    if (mouseDelta.distance != 0) {
      const mouseMoveSensitivity = 0.003;
      applyDeltaYawPitch(
        deltaYaw: -mouseDelta.dx * mouseMoveSensitivity,
        deltaPitch: mouseDelta.dy * mouseMoveSensitivity,
      );
    }
  }

  void resetCamera() {
    rotation.setFromTwoVectors(Vector3(0, 0, 1), -position);
    Mouse.reset();
  }

  void applyDeltaYawPitch({
    required double deltaYaw,
    required double deltaPitch,
  }) {
    final yawRotation = Quaternion.axisAngle(Vector3(0, 1, 0), deltaYaw);
    final pitchRotation = Quaternion.axisAngle(Vector3(1, 0, 0), deltaPitch);

    rotation.setFrom((rotation * yawRotation) * pitchRotation);
    rotation.normalize();
  }

  void accelerate(double distance) {
    position += forward..scale(distance);
  }

  void strafe(double distance) {
    final direction = forward.cross(_up)
      ..normalize()
      ..scale(distance);
    position += direction;
  }

  static const moveSpeed = 8;
  static const strafingSpeed = 16;

  static final _up = Vector3(0, 1, 0);
}
