import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:holiday_break_hackaton/main.dart';

final class Paddle extends RectangleComponent
    with HasGameReference<BrickBreakerGame> {
  Paddle() : super(size: Vector2(250, 25), paint: BasicPalette.green.paint());

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = Vector2(game.size.x / 2 - 125, game.size.y - 75);
    add(RectangleHitbox(isSolid: true));
  }

  void move(Vector2 delta) {
    position.add(Vector2(delta.x, 0));
  }
}
