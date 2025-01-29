import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:holiday_break_hackaton/brick_breaker_game.dart';

final class Wall extends SpriteComponent
    with HasGameReference<BrickBreakerGame> {
  Wall({required super.position, required width, required height})
      : super(size: Vector2(width, height));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('wall2.png');

    add(RectangleHitbox(isSolid: true));
  }
}
