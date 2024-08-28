import 'package:example/player.dart';
import 'package:example/playground_game.dart';
import 'package:flame/components.dart' show HasGameRef;
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/game.dart';

class KeyboardControlledCamera extends CameraComponent3D
    with HasGameRef<PlaygroundGame> {
  KeyboardControlledCamera({
    super.world,
    super.viewport,
    super.viewfinder,
    super.backdrop,
    super.hudComponents,
  }) : super(
          projection: CameraProjection.perspective,
          mode: CameraMode.free,
          up: Vector3(0, 1, 0),
          target: Vector3(0, 0, -1),
          fovY: 60,
        );

  final double moveSpeed = 0.9;
  final double rotationSpeed = 0.3;
  final double panSpeed = 2;
  final double orbitalSpeed = 0.5;

  Player get player => game.world.player;

  @override
  void update(double dt) {
    final origin = player.position;
    position.setFrom(origin);
    target.setFrom(origin + player.forward);
  }
}
