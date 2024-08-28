import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:pointer_lock/pointer_lock.dart';

class Mouse {
  static Offset getDelta() {
    final delta = _delta;
    _delta = Offset.zero;
    return delta;
  }

  static Offset _delta = Offset.zero;

  static final _lock = PointerLock();

  static ValueChanged<PointerDataPacket>? _onPointerDataPacket;

  static Future<void> init() async {
    _onPointerDataPacket = PlatformDispatcher.instance.onPointerDataPacket;

    PlatformDispatcher.instance.onPointerDataPacket = (packet) async {
      _onPointerDataPacket?.call(packet);

      // If any of the data events is a move or hover we should get a new delta.
      final hasPointerMoved = packet.data.any((e) {
        return e.change == PointerChange.move ||
            e.change == PointerChange.hover;
      });

      // If the user is dragging primaryMouseButton
      final isDragging = packet.data.any((e) {
        return e.buttons & kPrimaryMouseButton != 0;
      });

      if (isDragging && hasPointerMoved) {
        _delta = await _lock.lastPointerDelta();
      }
    };
  }

  static Future<void> dispose() async {
    if (_onPointerDataPacket != null) {
      PlatformDispatcher.instance.onPointerDataPacket = _onPointerDataPacket;
    }
  }

  static Future<void> reset() async {
    _delta = Offset.zero;
  }
}
