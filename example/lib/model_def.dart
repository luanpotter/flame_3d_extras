import 'package:flame_3d/game.dart';
import 'package:flame_3d_extras/extensions/matrix4_utils.dart';
import 'package:flame_3d_extras/model/model.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flame_3d_extras/parser/model_parser.dart';

class ModelDef {
  static late List<ModelDef> models;

  final String name;
  final String desc;
  final String source;
  final Matrix4 transform;
  final Model model;

  ModelDef({
    required this.name,
    required this.desc,
    required this.source,
    required this.transform,
    required this.model,
  });

  ModelComponent toComponent() {
    return ModelComponent(
      model: model,
    )..transform.setFrom(Transform3D.fromMatrix4(transform));
  }

  static Future<ModelDef> load({
    required String name,
    required String desc,
    required String source,
    Matrix4? transform,
  }) async {
    return ModelDef(
      name: name,
      desc: desc,
      source: source,
      transform: transform ?? Matrix4.identity(),
      model: await _parse(name),
    );
  }

  static Future<Model> _parse(String name) async {
    try {
      return await ModelParser.parse('objects/$name');
    } catch (e) {
      // ignore: avoid_print
      print('Error loading model $name: $e');
      rethrow;
    }
  }

  static Future<void> init() async {
    models = [
      await ModelDef.load(
        name: 'donut/donut.obj',
        desc: 'Static OBJ file example',
        source: 'https://github.com/flame-engine/defend_the_donut/',
      ),
      await ModelDef.load(
        name: 'animated-triangle.gltf',
        desc: 'Simple non-skeletal animation on a 2D triangle.',
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/AnimatedTriangle',
      ),
      await ModelDef.load(
        name: 'box-animated.glb',
        desc: 'Simple skeletal animation on a 3D box.',
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/BoxAnimated',
      ),
      await ModelDef.load(
        name: 'cube.glb',
        desc: 'Simple 3D cube.',
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/Cube',
      ),
      await ModelDef.load(
        name: 'duck.glb',
        desc: 'Simple 3D duck.',
        transform: matrix4(
          scale: Vector3.all(160.0),
        ),
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/Duck',
      ),
      await ModelDef.load(
        name: 'metal.glb',
        desc: 'Simple 3D spheres with varying metal material.',
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/MetalRoughSpheres',
      ),
      await ModelDef.load(
        name: 'rogue.glb',
        desc: 'Low-poly 3D rogue character with several animations.',
        source: 'https://kaylousberg.itch.io/kaykit-adventurers',
      ),
      await ModelDef.load(
        name: 'simple-skin.gltf',
        desc: 'Simple skinning animation over a rectangle.',
        source:
            'https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/SimpleSkin',
      ),
    ];
  }
}
