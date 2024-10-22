import 'package:flame_3d_extras/parser/gltf/gltf_node.dart';

enum AnimationPath {
  translation('translation'),
  rotation('rotation'),
  scale('scale'),
  weights('weights'),
  ;

  final String value;

  const AnimationPath(this.value);

  static AnimationPath valueOf(String value) {
    return values.firstWhere((e) => e.value == value);
  }

  static AnimationPath? parse(Map<String, Object?> map, String key) {
    return Parser.stringEnum(map, key, valueOf);
  }
}
