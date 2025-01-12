import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:holiday_break_hackaton/main.dart';

final class Brick extends SpriteComponent
    with HasGameReference<BrickBreakerGame> {
  Brick({super.position}) : super(size: Vector2(96, 48));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('brick.png', srcSize: Vector2(48, 24));

    add(RectangleHitbox(isSolid: true));
  }
}
