import 'dart:math';

import 'package:normal/normal.dart';

import 'package:flame/game.dart';

import 'package:spears_and_rings/components/enemy.dart';
import 'package:spears_and_rings/components/spear.dart';

import 'package:spears_and_rings/game_design.dart';

import 'package:flame/collisions.dart';

class CompHandling {
  // Spear parameters
  final double _spear_init_x_pos = 0.75;
  final double _spear_init_y_pos = 0.5;
  final double _spear_init_x_size = 0.25;
  final double _spear_init_y_size = 0.05;

  // Enemy parameters
  final double _enemy_init_x_size = 0.05;
  final double _enemy_init_y_size = 0.1;

  // Spear
  Vector2 _spearInitPos(final Vector2 _canvasSize) {
    final Vector2 _position = Vector2(
      _canvasSize[0] * _spear_init_x_pos,
      _canvasSize[1] * _spear_init_y_pos,
    );
    return _position;
  }

  // Vector2 _spearInitSize(final Vector2 _canvasSize) {
  //   final Vector2 _size = Vector2(_canvasSize[0] * _spear_init_x_size,
  //       _canvasSize[1] * _spear_init_y_size);
  //   return _size;
  // }

  List<Vector2> _spearVertices(final Vector2 _canvasSize) {
    final List<Vector2> _vertices = [
      Vector2(0, _canvasSize[1] * _spear_init_y_size * 0.5),
      Vector2(_canvasSize[0] * _spear_init_x_size * 0.25,
          _canvasSize[1] * _spear_init_y_size),
      Vector2(_canvasSize[0] * _spear_init_x_size * 0.25,
          _canvasSize[1] * _spear_init_y_size * 0.75),
      Vector2(_canvasSize[0] * _spear_init_x_size,
          _canvasSize[1] * _spear_init_y_size * 0.75),
      Vector2(_canvasSize[0] * _spear_init_x_size,
          _canvasSize[1] * _spear_init_y_size * 0.25),
      Vector2(_canvasSize[0] * _spear_init_x_size * 0.25,
          _canvasSize[1] * _spear_init_y_size * 0.25),
      Vector2(_canvasSize[0] * _spear_init_x_size * 0.25, 0),
    ];
    return _vertices;
  }

  Future<void> initSpear(
    final Vector2 _canvasSize,
    _addCharacter,
  ) async {
    final Vector2 _position = _spearInitPos(_canvasSize);
    //final Vector2 _size = _spearInitSize(_canvasSize);
    final List<Vector2> _vertices = _spearVertices(_canvasSize);
    _addCharacter(Spear(_vertices, _position));
    //_addCharacter(Spear(_position, _size, 0));
  }

  // Enemy
  Vector2 _enemyInitPos(final Vector2 _canvasSize) {
    // Ölç.. Yavaş mı çalışıyor ?
    var rng = Random();
    final double _enemy_init_y_pos = (rng.nextDouble());

    return Vector2(0, _canvasSize[1] * _enemy_init_y_pos);
  }

  Vector2 _enemyInitSize(final Vector2 _canvasSize) {
    return Vector2(_canvasSize[0] * _enemy_init_x_size,
        _canvasSize[1] * _enemy_init_y_size);
  }

  Vector2 _enemyInitVelocity(final Vector2 _canvasSize) {
    return Vector2(-250, 0);
  }

  Vector2 _enemyInitAcceleration(final Vector2 _canvasSize) {
    return Vector2(0, 0);
  }

  void spawnEnemy(
    final Vector2 _canvasSize,
    GameDesign _gameDesign,
    _addCharacter,
    _removeCharacter,
  ) {
    final Vector2 _position = _enemyInitPos(_canvasSize);
    final Vector2 _size = _enemyInitSize(_canvasSize);
    final Vector2 _velocity = _enemyInitVelocity(_canvasSize);
    final Vector2 _acceleration = _enemyInitAcceleration(_canvasSize);

    _addCharacter(
      Enemy(
        _position,
        _size,
        _velocity,
        _acceleration,
        _removeCharacter,
        _canvasSize,
      ),
    );
  }
}
