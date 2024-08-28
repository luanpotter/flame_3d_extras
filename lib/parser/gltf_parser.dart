import 'package:flame/flame.dart';
import 'package:flame_3d_extras/model/model.dart';
import 'package:flame_3d_extras/parser/gltf/gltf_root.dart';
import 'package:flame_3d_extras/parser/model_parser.dart';

/// Parses GLB and GLTF file formats as per specified by:
/// https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.pdf
class GltfParser extends ModelParser {
  @override
  Future<Model> parseModel(String filePath) async {
    final root = await parseGltf(filePath);
    return root.toFlameModel();
  }

  Future<GltfRoot> parseGltf(String filePath) async {
    final content = await Flame.assets.readJson(filePath);
    return GltfRoot.from(
      prefix: ModelParser.prefix(filePath),
      json: content,
      chunks: [],
    );
  }
}
