import 'package:flame_3d_extras/model/model.dart';
import 'package:flame_3d_extras/parser/glb_parser.dart';
import 'package:flame_3d_extras/parser/gltf_parser.dart';
import 'package:flame_3d_extras/parser/obj_parser.dart';

abstract class ModelParser {
  Future<Model> parseModel(String filePath);

  static Future<Model> parse(String filePath) async {
    final parser = _getParser(filePath);
    return parser.parseModel(filePath);
  }

  static ModelParser _getParser(String filePath) {
    if (filePath.endsWith('.gltf')) {
      return gltf;
    } else if (filePath.endsWith('.glb')) {
      return glb;
    } else if (filePath.endsWith('.obj')) {
      return obj;
    } else {
      throw ArgumentError('Unsupported file type: $filePath');
    }
  }

  static GltfParser gltf = GltfParser();
  static GlbParser glb = GlbParser();
  static ObjParser obj = ObjParser();

  static String prefix(String filePath) {
    return filePath.substring(0, filePath.lastIndexOf('/') + 1);
  }
}
