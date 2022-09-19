import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:spears_and_rings/components/drag_screen.dart';
import 'package:spears_and_rings/components/score_panel.dart';

import 'package:spears_and_rings/game_design.dart';
import 'package:spears_and_rings/game_state.dart';

import 'package:spears_and_rings/components/enemy.dart';
import 'package:spears_and_rings/component_handling.dart';
import 'package:flame/src/components/route.dart';

class GameEngine extends FlameGame
    with HasTappables, HasDraggables, HasCollisionDetection {
  late final RouterComponent router;
  @override
  late Vector2 canvasSize;

  late GameDesign gameDesign;
  late GameState gameState;
  late ScorePanel scorePanel;

  CompHandling compHandling = CompHandling();

  @override
  void onGameResize(final Vector2 _canvasSize) {
    canvasSize = _canvasSize;
    super.onGameResize(canvasSize);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // router = RouterComponent(
    //   routes: {
    //     "home": Route(),
    //   },
    //   initialRoute: "home",
    // );

    // Init GameInfo
    gameDesign = GameDesign();
    gameState = GameState();
    scorePanel = ScorePanel();

    // Add drag screen to control the spear
    add(DragScreen(canvasSize));

    // Init Spear
    await compHandling.initSpear(canvasSize, addCharCallback);
  }

  @override
  void render(final Canvas _canvas) {
    super.render(_canvas);
    scoreBoard(_canvas);
  }

  void scoreBoard(final Canvas _canvas) {
    const TextStyle textStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      fontSize: 100,
      fontWeight: FontWeight.w900,
    );

    final TextSpan textSpan = TextSpan(
      text: gameState.score.toString(),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: canvasSize[0],
    );

    final xCenter = (canvasSize[0] - textPainter.width) / 2;
    final yCenter = (canvasSize[1] - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(_canvas, offset);
  }

  @override
  void update(final double _dt) {
    super.update(_dt);
    gameState.last_spawn_timer += _dt;
    if (gameState.last_spawn_timer > gameDesign.spawn_offset) {
      gameState.last_spawn_timer = 0;
      compHandling.spawnEnemy(
        canvasSize,
        gameDesign,
        addCharCallback,
        removeCharCallback,
      );
    }
  }

  // Callbacks
  void addCharCallback(var _character) {
    add(_character);
    if (_character is Enemy) {
      gameState.current_enemy++;
    }
  }

  void removeCharCallback(var _character) {
    remove(_character);
    if (_character is Enemy) {
      gameState.current_enemy--;
      if (_character.is_killed) {
        gameState.score++;
      }
    }
  }
}
