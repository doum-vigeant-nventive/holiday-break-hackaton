import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:holiday_break_hackaton/ball.dart';
import 'package:holiday_break_hackaton/brick.dart';
import 'package:holiday_break_hackaton/paddle.dart';
import 'package:holiday_break_hackaton/play_area.dart';
import 'package:holiday_break_hackaton/santa.dart';
import 'package:holiday_break_hackaton/wall.dart';

const double gameWidth = 800;
const double gameHeight = 900;

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Container(
            // padding: const EdgeInsets.all(48),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/back.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
            ),
            child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: SizedBox(
                            width: gameWidth,
                            height: gameHeight,
                            child: GameWidget(
                              game: BrickBreakerGame(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );


final class BrickBreakerGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  BrickBreakerGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  late final Paddle paddle;
  late final Ball ball;
  late List<Brick> bricks;
  late final Santa santa;

  double get width => size.x;
  double get height => size.y;
  double get ballRadius => width * 0.02;
  double get paddleLength => width * 0.2;
  double get paddleHeight => 48;

  bool gameStarted = false;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    add(PlayArea());
    final backgroundImage = SpriteComponent(
      sprite: Sprite(
        await images.load('bricks-background.jpg'),
        srcSize: Vector2(width, height),
        srcPosition: Vector2(0.0, 0.0),
      ),
    );

    add(backgroundImage);
    addAll(getWalls());

    santa = Santa(size: Vector2(500.0, 200.0), position: Vector2(width / 2, 0));
    add(santa);

    paddle = Paddle(size: Vector2(paddleLength, paddleHeight));
    add(paddle);
    ball = Ball(size: ballRadius);
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

  Future<void> winGame() async {
    santa.animateDescent();
    remove(ball);
    await Future.delayed(const Duration(seconds: 4));
    santa.resetPosition(Vector2(width / 2, 0));
    add(ball);
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

  List<Wall> getWalls() {
    final walls = <Wall>[];
    walls.add(Wall(position: Vector2(0.0, 0.0), width: 150.0, height: 450.0));
    walls.add(Wall(
        position: Vector2(gameWidth - 150.0, 0.0),
        width: 150.0,
        height: 450.0));
    return walls;
  }

  List<Brick> getBricks() {
    final numberOfLines = 10;
    final numberOfBricksPerLine = 10;
    final bricks = <Brick>[];
    final buffer = (width - (numberOfBricksPerLine * brickWidth)) / 2;

    for (int line = 0; line < numberOfLines; line++) {
      final numberOfBricks =
          line.isOdd ? numberOfBricksPerLine - 1 : numberOfBricksPerLine;
      for (int brick = 0; brick < numberOfBricks; brick++) {
        final xPosition =
            brick * brickWidth + (line.isOdd ? brickWidth / 2 : 0) + buffer;
        final yPosition = line * brickHeight + 200;

        bricks.add(Brick(position: Vector2(xPosition, yPosition)));
      }
    }

    return bricks;
  }
}
