import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:holiday_break_hackaton/brick.dart';
import 'package:holiday_break_hackaton/main.dart';
import 'package:holiday_break_hackaton/paddle.dart';

final class Ball extends CircleComponent
    with HasGameReference<BrickBreakerGame>, CollisionCallbacks {
  Ball({super.position}) : super(radius: 20, paint: BasicPalette.blue.paint());

  static const double speed = 500;
  static const double degree = math.pi / 180;

  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetPosition();
    add(CircleHitbox(radius: 20));
  }

  void resetPosition() {
    position = Vector2(game.size.x / 2 - 10, game.size.y - 115);
  }

  void resetBall() {
    resetPosition();
    final spawnAngle = randomSpawnAngle;
    velocity = Vector2(
      math.cos(spawnAngle * degree) * speed,
      math.sin(spawnAngle * degree) * speed,
    );
  }

  double get randomSpawnAngle =>
      lerpDouble(0, 360, math.Random().nextDouble())!;

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    final collisionPoint = intersectionPoints.first;

    if (other is ScreenHitbox) {
      final isSideCollision = collisionPoint.x == 0 ||
          collisionPoint.x.toStringAsFixed(1) == game.size.x.toStringAsFixed(1);
      if (isSideCollision) {
        velocity.x = -velocity.x;
      } else {
        // TODO: Game over si la balle touche le bas.
        velocity.y = -velocity.y;
      }
    }

    if (other is Brick) {
      final leftBorder = other.position.x;
      final rightBorder = leftBorder + other.width;
      final isSideCollision =
          collisionPoint.x == leftBorder || collisionPoint.x == rightBorder;

      if (isSideCollision) {
        velocity.x = -velocity.x;
      } else {
        velocity.y = -velocity.y;
      }
      other.removeFromParent();
    }

    if (other is Paddle) {
      final topBorder = other.position.y;
      final isTopCollision = collisionPoint.y == topBorder;

      // TODO: Changer l'angle en fonction d'où sur le paddle ça atterit.
      if (isTopCollision) {
        velocity.y = -velocity.y;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
