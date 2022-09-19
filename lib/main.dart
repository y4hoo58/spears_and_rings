import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';

import 'package:spears_and_rings/game_engine.dart';

void main() async {
  GameEngine gameEngine = GameEngine();

  // Todo : Neden ?
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscapeRightOnly();

  runApp(GameWidget(
    game: gameEngine,
  ));
}
