import 'dart:async';

import 'package:example/components/crosshair.dart';
import 'package:example/components/grid_lines.dart';
import 'package:example/components/visual_light.dart';
import 'package:example/key_event_handler.dart';
import 'package:example/keyboard_controlled_camera.dart';
import 'package:example/menu/menu.dart';
import 'package:example/menu/pause_menu.dart';
import 'package:example/model_def.dart';
import 'package:example/mouse.dart';
import 'package:example/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' show FlameGame, GameWidget;
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/game.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(GameWidget(game: PlaygroundGame()));
}

class PlaygroundGame extends FlameGame<PlaygroundWorld3D>
    with
        HasKeyboardHandlerComponents,
        SecondaryTapDetector,
        CanPause<PlaygroundWorld3D> {
  late Crosshair crosshair;
  late GridLines gridLines;
  Menu? menu;

  bool showLights = false;

  PlaygroundGame()
      : super(
          world: PlaygroundWorld3D(),
          camera: KeyboardControlledCamera(),
        );

  @override
  FutureOr<void> onLoad() async {
    await camera.viewport.add(crosshair = Crosshair());
    await world.add(gridLines = GridLines());
    await super.onLoad();
  }

  @override
  KeyboardControlledCamera get camera =>
      super.camera as KeyboardControlledCamera;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      if (isPaused) {
        resume();
      } else {
        pause();
      }
      return KeyEventResult.handled;
    }

    for (final (digit, idx) in KeyEventHandler.digits) {
      if (keysPressed.contains(digit)) {
        if (idx == 0) {
          world.clearModel();
          return KeyEventResult.handled;
        }
        final model = ModelDef.models.elementAtOrNull(idx - 1);
        if (model != null) {
          world.setModel(model);
          return KeyEventResult.handled;
        }
      }
    }

    if (keysPressed.contains(LogicalKeyboardKey.f1)) {
      crosshair.toggle();
    } else if (keysPressed.contains(LogicalKeyboardKey.f2)) {
      gridLines.toggle();
    } else if (keysPressed.contains(LogicalKeyboardKey.f3)) {
      showLights = !showLights;
    } else if (keysPressed.contains(LogicalKeyboardKey.f12)) {
      world.player.resetPlayer();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onSecondaryTapDown(TapDownInfo info) {
    world.player.resetCamera();
  }

  void _updateMenu(Menu menu) {
    if (this.menu != menu) {
      _removeMenu();
      camera.viewport.add(this.menu = menu);
    }
  }

  void _removeMenu() {
    final currentMenu = menu;
    if (currentMenu != null) {
      camera.viewport.remove(currentMenu);
      menu = null;
    }
  }

  @override
  void pause() {
    super.pause();
    _updateMenu(PauseMenu());
  }

  @override
  void resume() {
    _removeMenu();
    super.resume();
  }
}

class PlaygroundWorld3D extends World3D with TapCallbacks {
  PlaygroundWorld3D()
      : super(
          clearColor: const Color(0xFF3C3C3C),
        );

  late Player player;
  ModelComponent? model;

  @override
  PlaygroundGame get game => findParent<PlaygroundGame>()!;
  KeyboardControlledCamera get camera => game.camera;

  @override
  FutureOr<void> onLoad() async {
    await ModelDef.init();

    await add(player = Player());
    await setupLights();
    await setModel(ModelDef.models[1]);

    await Mouse.init();
    game.resume();
  }

  Future<void> setupLights() async {
    await add(
      LightComponent.ambient(
        intensity: 0.75,
      ),
    );

    await pointLight(Vector3.zero(), const Color(0xFFFFFFFF));
    await pointLight(Vector3(0, 0, -6), const Color(0xFFFFFFFF));
    await pointLight(Vector3(0, 3, 6), const Color(0xFFFFFFFF));
  }

  Future<void> setModel(ModelDef modelDef) async {
    await clearModel();
    final model = modelDef.toComponent();
    await add(
      this.model = model,
    );
    if (model.model.animations.isNotEmpty) {
      model.playAnimationIdx(0);
    }
  }

  Future<void> clearModel() async {
    final currentModel = model;
    if (currentModel != null) {
      remove(currentModel);
    }
  }

  Future<void> pointLight(
    Vector3 position,
    Color color,
  ) async {
    await addAll([
      LightComponent.point(
        position: position,
        color: color,
        intensity: 20.0,
      ),
      VisualLight(
        position: position,
        color: color,
      ),
    ]);
  }
}
