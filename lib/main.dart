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
  late final Paddle paddle;
  late final Ball ball;
  late List<Brick> bricks;

  double get width => size.x;
  double get height => size.y;
  double get ballRadius => width * 0.02;
  double get paddleLength => width * 0.2;
  double get paddleHeight => ballRadius * 2;

  bool gameStarted = false;

  @override
  Future<void> onLoad() async {
    final backgroundImage = SpriteComponent(
      sprite: Sprite(
        await images.load('bricks-background.jpg'),
        srcSize: Vector2(width, height),
      ),
    );
    add(backgroundImage);
    add(ScreenHitbox());
    paddle = Paddle(size: Vector2(paddleLength, paddleHeight));
    add(paddle);
    ball = Ball(radius: ballRadius);
    add(ball);
    bricks = getBricks();
    addAll(bricks);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    paddle.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (!gameStarted) {
      ball.throwBall();
      gameStarted = true;
    }
  }

  void resetGame() {
    resetBallAndPaddle();
    resetBricks();
  }

  void resetBallAndPaddle() {
    gameStarted = false;
    ball.resetPosition();
    ball.resetVelocity();
    paddle.resetPosition();
  }

  void resetBricks() {
    removeAll(children.query<Brick>());
    addAll(bricks);
  }

  List<Brick> getBricks() {
    final numberOfLines = 10;
    final numberOfBricksPerLine = (width / brickWidth).floor();
    final bricks = <Brick>[];

    for (int line = 0; line < numberOfLines; line++) {
      final numberOfBricks =
          line.isOdd ? numberOfBricksPerLine - 1 : numberOfBricksPerLine;
      for (int brick = 0; brick < numberOfBricks; brick++) {
        final xPosition =
            brick * brickWidth + (line.isOdd ? brickWidth / 2 : 0);
        final yPosition = line * brickHeight;

        bricks.add(Brick(position: Vector2(xPosition, yPosition)));
      }
    }

    return bricks;
  }
}
