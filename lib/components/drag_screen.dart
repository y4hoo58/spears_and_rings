import 'package:flutter/rendering.dart';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';

import 'package:spears_and_rings/components/laser.dart';

class DragScreen extends PositionComponent
    with Tappable, Draggable, GestureHitboxes {
  late final ShapeHitbox gesturebox;

  static int drag_counter = 0;

  static bool isTapDown = false;
  static bool isTapUp = false;

  static Vector2 tapUpPosition = Vector2(0, 0);
  static Vector2 tapDownPosition = Vector2(0, 0);

  static List<Vector2> drag_positions = [];
  static List<Vector2> drag_deltas = [];

  final Vector2 canvasSize;

  DragScreen(this.canvasSize);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    gesturebox = RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(canvasSize[0], canvasSize[1]),
      anchor: Anchor.topLeft,
    );
    gesturebox.collisionType = CollisionType.inactive;

    add(gesturebox);
  }

  @override
  void render(final Canvas _canvas) {
    super.render(_canvas);
  }

  @override
  void update(final double _dt) {
    super.update(_dt);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    isTapDown = true;
    tapDownPosition = info.eventPosition.global;
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    isTapDown = false;
    isTapUp = true;
    tapUpPosition = info.eventPosition.global;
    return true;
  }

  @override
  bool onDragStart(DragStartInfo info) {
    isTapDown = false;
    super.onDragStart(info);
    drag_counter++;
    return true;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    super.onDragUpdate(info);
    drag_positions.add(info.eventPosition.global);
    drag_deltas.add(info.delta.global);
    return true;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    drag_counter--;
    return isDragged;
  }
}
