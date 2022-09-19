import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class ScorePanel {
  void render_panel(
      final Canvas _canvas, final Vector2 _canvasSize, final int _score) {
    const TextStyle textStyle = TextStyle(
      color: Colors.green,
      fontSize: 100,
    );

    final TextSpan textSpan = TextSpan(
      text: "Deneme",
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: _canvasSize[0],
    );

    final double xCenter = 500;
    final double yCenter = 500;
    final Offset offset = Offset(xCenter, yCenter);
    textPainter.paint(_canvas, offset);
  }
}
