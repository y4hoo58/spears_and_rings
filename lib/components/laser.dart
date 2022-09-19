import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:flutter/rendering.dart';

class Laser extends PositionComponent with CollisionCallbacks {
  final paint = Paint();

  double alive_time = 0;
  final double max_alive_time = 0.05;
  late ShapeHitbox hitbox;

  Laser(
    final Vector2 _position,
    final Vector2 _size,
  ) : super(
          position: _position,
          size: _size,
          anchor: Anchor.topRight,
        );

  @override
  Future<void> onLoad() async {
    // Create a hitbox
    hitbox = RectangleHitbox();

    add(hitbox);
  }

  @override
  void render(final Canvas _canvas) {
    super.render(_canvas);
    paint.color = const Color.fromRGBO(255, 255, 0, 1.0);
    _canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(final double _dt) {
    super.update(_dt);
    alive_time += _dt;
    if (alive_time > max_alive_time) {
      kill();
    }
  }

  void kill() {
    removeFromParent();
  }
}
