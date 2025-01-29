import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:holiday_break_hackaton/brick.dart';
import 'package:holiday_break_hackaton/brick_breaker_game.dart';
import 'package:holiday_break_hackaton/paddle.dart';
import 'package:holiday_break_hackaton/play_area.dart';
import 'package:holiday_break_hackaton/wall.dart';

final class Ball extends SpriteComponent
    with HasGameReference<BrickBreakerGame>, CollisionCallbacks {
  Ball({required size}) : super(anchor: Anchor.center);

  static const double speed = 450;
  static const double degree = math.pi / 180;

  Vector2 velocity = Vector2.zero();

  double get randomSpawnAngle =>
      lerpDouble(-45, -135, math.Random().nextDouble())!;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'elf.png',
      srcSize: Vector2(48, 48),
    );
    await super.onLoad();
    resetPosition();
    add(CircleHitbox());
  }

  void resetPosition() {
    position = Vector2(
      game.width / 2,
      game.height * 0.95 - game.paddleHeight - game.ballRadius,
    );
  }

  void resetVelocity() {
    velocity = Vector2.zero();
  }

  void throwBall() {
    final spawnAngle = randomSpawnAngle;
    velocity = Vector2(
      math.cos(spawnAngle * degree) * speed,
      math.sin(spawnAngle * degree) * speed,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    angle = velocity.screenAngle();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    final collisionPoint = intersectionPoints.first;

    if (other is PlayArea) {
      final isSideCollision = collisionPoint.x <= 0 ||
          collisionPoint.x.toStringAsFixed(1) == game.width.toStringAsFixed(1);
      final isTopCollision = collisionPoint.y <= 0;

      if (isSideCollision) {
        velocity.x = -velocity.x;
      } else if (isTopCollision) {
        velocity.y = -velocity.y;
      } else {
        game.resetBallAndPaddle();
      }
    } else if (other is Wall) {
      final leftBorder = other.position.x;
      final rightBorder = leftBorder + other.width;
      final isSideCollision =
          collisionPoint.x <= leftBorder || collisionPoint.x >= rightBorder;
      if (isSideCollision) {
        velocity.x = -velocity.x;
      } else {
        velocity.y = -velocity.y;
      }
    } else if (other is Brick) {
      final leftBorder = other.position.x;
      final rightBorder = leftBorder + other.width;
      final isSideCollision =
          collisionPoint.x <= leftBorder || collisionPoint.x >= rightBorder;

      if (isSideCollision) {
        velocity.x = -velocity.x;
      } else {
        velocity.y = -velocity.y;
      }
      other.removeFromParent();

      if (game.children.query<Brick>().length == 1) {
        game.winGame();
      }
    } else if (other is Paddle) {
      FlameAudio.play('boing.wav');
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.height * 0.3;
    } else {
      throw Exception('Unknown collision');
    }
  }
}
