import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_animation.dart';

class AnimationState {
  ModelAnimation? animationRef;
  double clock = 0.0;

  void startAnimation(
    ModelAnimation? animation, {
    bool resetClock = true,
  }) {
    animationRef = animation;
    if (resetClock) {
      reset();
    }
  }

  void update(double dt) {
    final animation = animationRef;
    if (animation == null) {
      return;
    }

    clock += dt;
    while (clock > animation.lastTime) {
      clock -= animation.lastTime;
    }
  }

  Matrix4 maybeTransform(int nodeIndex, Matrix4 transform) {
    final animation = animationRef?.nodes[nodeIndex];
    if (animation == null) {
      return transform;
    }

    final result = transform.clone();
    animation.sampleInto(clock, result);
    return result;
  }

  void reset() {
    clock = 0.0;
  }
}
