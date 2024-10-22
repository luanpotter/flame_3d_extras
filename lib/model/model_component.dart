import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d/graphics.dart';
import 'package:flame_3d_extras/model/animation_state.dart';
import 'package:flame_3d_extras/model/model.dart';

class ModelComponent extends Object3D {
  final Model model;

  final Set<int> _hiddenNodes = {};
  final AnimationState _animation = AnimationState();

  ModelComponent({
    required this.model,
    super.position,
    super.rotation,
    super.scale,
  });

  Aabb3 get aabb => _aabb
    ..setFrom(model.aabb)
    ..transform(transformMatrix);
  final Aabb3 _aabb = Aabb3();

  @override
  void bind(GraphicsDevice device) {
    final nodes = model.processNodes(_animation);
    for (final MapEntry(key: idx, value: node) in nodes.entries) {
      if (_hiddenNodes.contains(idx)) {
        continue;
      }

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
    _animation.update(dt);
  }

  void playAnimationByName(String name, {bool resetClock = true}) {
    final animation = model.animations.where((e) => e.name == name).firstOrNull;
    if (animation == null) {
      throw ArgumentError('No animation with name $name');
    }
    _animation.startAnimation(animation, resetClock: resetClock);
  }

  void playAnimationByIdx(int idx, {bool resetClock = true}) {
    final animation = model.animations[idx];
    _animation.startAnimation(animation, resetClock: resetClock);
  }

  void stopAnimation() {
    _animation.startAnimation(null);
  }

  void hideNodeByName(String name, {bool hidden = true}) {
    final node = model.nodes.entries.firstWhere((e) => e.value.name == name);
    if (hidden) {
      _hiddenNodes.add(node.key);
    } else {
      _hiddenNodes.remove(node.key);
    }
  }

  @override
  bool shouldCull(CameraComponent3D camera) {
    // TODO(luan): this actually does not work because of animations
    // it might end up culling something that is actually visible
    return camera.frustum.intersectsWithAabb3(aabb);
  }
}
