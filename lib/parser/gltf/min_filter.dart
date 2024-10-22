import 'package:flame_3d_extras/parser/gltf/gltf_node.dart';

/// Magnification filter. Valid values correspond to WebGL enums.
enum MinFilter {
  nearest('NEAREST', 9728),
  linear('LINEAR', 9729),
  nearestMipmapNearest('NEAREST_MIPMAP_NEAREST', 9984),
  linearMipmapNearest('LINEAR_MIPMAP_NEAREST', 9985),
  nearestMipmapLinear('NEAREST_MIPMAP_LINEAR', 9986),
  linearMipmapLinear('LINEAR_MIPMAP_LINEAR', 9987),
  ;

  final String name;
  final int value;

  const MinFilter(this.name, this.value);

  static MinFilter valueOf(int value) {
    return values.firstWhere((e) => e.value == value);
  }

  static MinFilter? parse(Map<String, Object?> map, String key) {
    return Parser.integerEnum(map, key, valueOf);
  }
}
