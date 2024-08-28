import 'dart:ui';

import 'package:example/playground_game.dart';
import 'package:flame/components.dart' show HasGameRef;
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d/resources.dart';

class VisualLight extends MeshComponent with HasGameRef<PlaygroundGame> {
  VisualLight({
    required Vector3 position,
    required Color color,
  }) : super(
          position: position,
          mesh: SphereMesh(
            radius: 0.05,
            material: SpatialMaterial(
              albedoColor: color,
            ),
          ),
        );

  @override
  void renderTree(Canvas canvas) {
    if (game.showLights) {
      super.renderTree(canvas);
    }
  }
}
