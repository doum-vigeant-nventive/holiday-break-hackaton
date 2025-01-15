import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:holiday_break_hackaton/main.dart';

const double brickWidth = 48;
const double brickHeight = 24;

final class Brick extends SpriteComponent
    with HasGameReference<BrickBreakerGame> {
  Brick({super.position}) : super(size: Vector2(brickWidth, brickHeight));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'brick4.png',
      srcSize: Vector2(brickWidth, brickHeight),
    );

    add(RectangleHitbox(isSolid: true));
  }
}
