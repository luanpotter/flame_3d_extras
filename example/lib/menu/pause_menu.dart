import 'package:example/menu/menu.dart';
import 'package:example/menu/menu_item.dart';
import 'package:example/mouse.dart';
import 'package:example/styles.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class PauseMenu extends Menu {
  static final _overlay = Paint()..color = const Color(0xAF000000);

  @override
  Future<void> onLoad() async {
    await add(
      MenuItem(
        textRenderer: Styles.textBig,
        text: '- continue -',
        positionProvider: (gameSize) => gameSize / 2,
        anchor: Anchor.center,
        onTap: game.resume,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(game.canvasSize.toRect(), _overlay);
  }
}

mixin CanPause<T extends World> on FlameGame<T> {
  bool _isPaused = true;

  bool get isPaused => _isPaused;

  void pause() {
    _isPaused = true;
    mouseCursor = MouseCursor.defer;
    Mouse.unlock();
  }

  void resume() {
    _isPaused = false;
    mouseCursor = SystemMouseCursors.none;
    Mouse.lock();
  }
}
