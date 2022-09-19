import 'dart:math';

import 'package:spears_and_rings/components/spear.dart';
import 'package:spears_and_rings/game_constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemy extends PositionComponent with CollisionCallbacks {
  bool is_alive = true;
  bool is_killed = false;

  final paint = Paint();

  late Vector2 velocity;

  late void Function(Enemy) removeCallback;

  late ShapeHitbox hitbox;

  late Vector2 screenSize;

  double opacity = 1;

  Enemy(
    final Vector2 _position,
    final Vector2 _size,
    final Vector2 _velocity,
    final Vector2 _acceleration,
    final Function(Enemy) _removeCallback,
    final Vector2 _screenSize,
  ) {
    position = _position;
    size = _size;
    anchor = Anchor.center;
    velocity = _velocity;
    removeCallback = _removeCallback;
    screenSize = _screenSize;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Create a "passive" hitbox
    hitbox = RectangleHitbox();
    hitbox.collisionType = CollisionType.passive;

    add(hitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    is_killed = true;
    //paint.color = const Color.fromRGBO(255, 0, 0, 1);
  }

  @override
  void render(final Canvas _canvas) {
    super.render(_canvas);
    if (is_alive) {
      paint.color = Color.fromRGBO(255, 0, 255, opacity);
      _canvas.drawRect(size.toRect(), paint);
    }
  }

  @override
  void update(final double _dt) {
    super.update(_dt);
    checkIsAlive();
    updatePosition(_dt);
    killSlowly();
    removeThis();
  }

  void updatePosition(final double _dt) {
    //Update vertical velocity
    velocity[1] = velocity[1] + (GameConstants.gravity[1] * _dt);

    // Update position
    if (is_alive) {
      position = position - (velocity * _dt);
    }

    angle += 0.02;
  }

  void checkIsAlive() {
    if ((position[0] > screenSize[0])) {
      is_alive = false;
    }
  }

  void killSlowly() {
    if (is_killed == true) {
      opacity -= 0.05;
      if (opacity < 0) {
        is_alive = false;
      }
    }
  }

  // Todo :removeFromParent() kullan daha sonra.
  void removeThis() {
    if (is_alive == false) {
      removeCallback(this);
    }
  }
}
