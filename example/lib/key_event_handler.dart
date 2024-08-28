import 'package:flame/components.dart';
import 'package:flutter/services.dart';

mixin KeyEventHandler implements KeyboardHandler {
  Set<Key> _keysDown = {};

  bool isKeyDown(Key key) => _keysDown.contains(key);

  bool isAnyDown(List<Key> keys) => _keysDown.containsAll(keys);

  @override
  bool onKeyEvent(KeyEvent event, Set<Key> keysPressed) {
    _keysDown = keysPressed;
    return propagateKeyEvent;
  }

  bool get propagateKeyEvent => true;

  static final digits = [
    (LogicalKeyboardKey.digit0, 0),
    (LogicalKeyboardKey.digit1, 1),
    (LogicalKeyboardKey.digit2, 2),
    (LogicalKeyboardKey.digit3, 3),
    (LogicalKeyboardKey.digit4, 4),
    (LogicalKeyboardKey.digit5, 5),
    (LogicalKeyboardKey.digit6, 6),
    (LogicalKeyboardKey.digit7, 7),
    (LogicalKeyboardKey.digit8, 8),
    (LogicalKeyboardKey.digit9, 9),
  ];
}

typedef Key = LogicalKeyboardKey;
