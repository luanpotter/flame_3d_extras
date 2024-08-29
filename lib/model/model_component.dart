import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d/graphics.dart';
import 'package:flame_3d_extras/model/model.dart';
import 'package:flame_3d_extras/model/model_animation.dart';

class ModelComponent extends Object3D {
  final Model model;
  ModelAnimation? _currentAnimation;

  ModelComponent({
    required this.model,
  });

  Aabb3 get aabb => _aabb
    ..setFrom(model.aabb)
    ..transform(transformMatrix);
  final Aabb3 _aabb = Aabb3();

  @override
  void bind(GraphicsDevice device) {
    final nodes = model.processNodes(_currentAnimation).values;
    for (final node in nodes) {
      final mesh = node.node.mesh;
      if (mesh != null) {
        device.jointsInfo.jointTransformsPerSurface = node.jointTransforms;
        // ignore: invalid_use_of_internal_member
        world.device
          ..model.setFrom(transformMatrix.multiplied(node.combinedTransform))
          ..bindMesh(mesh);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _currentAnimation?.update(dt);
  }

  void playAnimation(String name) {
    final animation = model.animations[name];
    if (animation == null) {
      throw ArgumentError('No animation with name $name');
    }
    animation.reset();
    _currentAnimation = animation;
  }

  void playAnimationIdx(int idx) {
    playAnimation(model.animations.keys.toList()[idx]);
  }

  void stopAnimation() {
    _currentAnimation = null;
  }

  @override
  bool shouldCull(CameraComponent3D camera) {
    // TODO(luan): this actually does not work because of animations
    // it might end up culling something that is actually visible
    return camera.frustum.intersectsWithAabb3(aabb);
  }
}
