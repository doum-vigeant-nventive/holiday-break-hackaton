import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:holiday_break_hackaton/ball.dart';
import 'package:holiday_break_hackaton/brick.dart';
import 'package:holiday_break_hackaton/paddle.dart';

void main() => runApp(GameWidget(game: BrickBreakerGame()));

final class BrickBreakerGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  final Paddle paddle = Paddle();
  final Ball ball = Ball();

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    add(paddle);
    add(ball);
    addAll(getBricks());
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    paddle.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    ball.resetBall();
  }

  List<Brick> getBricks() {
    // TODO: Générer les briques automatiquement.
    return [
      Brick(position: Vector2(0, 0)),
      Brick(position: Vector2(96, 0)),
      Brick(position: Vector2(192, 0)),
      Brick(position: Vector2(288, 0)),
      Brick(position: Vector2(384, 0)),
      Brick(position: Vector2(480, 0)),
      Brick(position: Vector2(576, 0)),
      Brick(position: Vector2(672, 0)),
      Brick(position: Vector2(768, 0)),
      Brick(position: Vector2(864, 0)),
      Brick(position: Vector2(0 - 48, 48)),
      Brick(position: Vector2(96 - 48, 48)),
      Brick(position: Vector2(192 - 48, 48)),
      Brick(position: Vector2(288 - 48, 48)),
      Brick(position: Vector2(384 - 48, 48)),
      Brick(position: Vector2(480 - 48, 48)),
      Brick(position: Vector2(576 - 48, 48)),
      Brick(position: Vector2(672 - 48, 48)),
      Brick(position: Vector2(768 - 48, 48)),
      Brick(position: Vector2(864 - 48, 48)),
      Brick(position: Vector2(0, 96)),
      Brick(position: Vector2(96, 96)),
      Brick(position: Vector2(192, 96)),
      Brick(position: Vector2(288, 96)),
      Brick(position: Vector2(384, 96)),
      Brick(position: Vector2(480, 96)),
      Brick(position: Vector2(576, 96)),
      Brick(position: Vector2(672, 96)),
      Brick(position: Vector2(768, 96)),
      Brick(position: Vector2(864, 96)),
    ];
  }
}
