import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'package:flutter/rendering.dart';
import 'package:spears_and_rings/components/laser.dart';
import 'package:spears_and_rings/components/drag_screen.dart';

class Spear extends PolygonComponent {
  @override
  final Paint paint = Paint();

  double opacity = 0;

  late final ShapeHitbox headHitbox;
  late final ShapeHitbox tailHitbox;

  Spear(
    final List<Vector2> _vertices,
    final Vector2 _position,
  ) : super(_vertices) {
    angle = 0;
    position = _position;
    anchor = Anchor.centerLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final List<Vector2> _arrow_head_vertices = [
      vertices[0],
      vertices[1],
      vertices[vertices.length - 1],
    ];

    final List<Vector2> _arrow_tail_vertices = [
      vertices[2],
      vertices[3],
      vertices[4],
      vertices[5],
    ];

    headHitbox = PolygonHitbox(_arrow_head_vertices);
    tailHitbox = PolygonHitbox(_arrow_tail_vertices);

    add(headHitbox);
    add(tailHitbox);
  }

  @override
  void render(final Canvas _canvas) {
    super.render(_canvas);
    paint.color = Color.fromRGBO(0, 255, 0, opacity);
  }

  // TODO : Fix the bug.
  @override
  void update(final double _dt) {
    super.update(_dt);

    // If the person touches the screen, make spear visible else spear is unvisible.
    if (DragScreen.isTapDown) {
      opacity = 1;
      //position = DragScreen.tapDownPosition;
      position[0] = DragScreen.tapDownPosition[0] - size[0] * 0.4;
      position[1] = DragScreen.tapDownPosition[1];
      headHitbox.collisionType = CollisionType.active;
    } else {
      if (DragScreen.drag_counter > 0) {
        opacity = 1;
        headHitbox.collisionType = CollisionType.active;
      } else {
        headHitbox.collisionType = CollisionType.inactive;
        opacity = 0;
        angle = 0;
      }
    }

    // If the person is tapped to the screen, fire the laser
    if (DragScreen.isTapUp) {
      if (DragScreen.drag_positions.length == 0) {
        position[0] = DragScreen.tapUpPosition[0] - size[0] * 0.4;
        position[1] = DragScreen.tapUpPosition[1];
      }

      add(Laser(
        Vector2(-size[0] * 0.025, size[1] * 0.5 - (size[1] * 0.25) * 0.5),
        Vector2(position[0], size[1] * 0.25),
      ));
      // Todo :Fix? Risky.
      DragScreen.isTapUp = false;
    }

    Vector2 _vec1;
    Vector2 _vec2;

    if (DragScreen.drag_counter == 2 && DragScreen.drag_positions.length == 2) {
      if (DragScreen.drag_positions[0][0] > DragScreen.drag_positions[1][0]) {
        _vec1 = DragScreen.drag_positions[0];
        _vec2 = DragScreen.drag_positions[1];
      } else {
        _vec1 = DragScreen.drag_positions[1];
        _vec2 = DragScreen.drag_positions[0];
      }
      _vec2 = _vec2 - _vec1;

      angle = atan(_vec2[1] / _vec2[0]);

      //position += DragScreen.drag_deltas[0];
      position[0] = DragScreen.drag_positions[0][0] - size[0] * 0.4;
      position[1] = DragScreen.drag_positions[0][1];
      //position = DragScreen.drag_positions[0];
    } else if (DragScreen.drag_counter == 1 &&
        DragScreen.drag_positions.length == 1) {
      //TODO :Is try catch needed?
      try {
        //position = position + (DragScreen.drag_deltas[0]);
        position[0] = DragScreen.drag_positions[0][0] - size[0] * 0.4;
        position[1] = DragScreen.drag_positions[0][1];
        //position = DragScreen.drag_positions[0];

      } on Exception {}
    }
    DragScreen.drag_positions = [];
    DragScreen.drag_deltas = [];
  }
}
