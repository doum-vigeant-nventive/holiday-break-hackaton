import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:holiday_break_hackaton/main.dart';

final class Paddle extends SpriteComponent
    with HasGameReference<BrickBreakerGame> {
  Paddle({required super.size})
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

     sprite = await Sprite.load(
      'paddle.png',
      srcSize: Vector2(160, 48),
    );

    resetPosition();
    add(RectangleHitbox(isSolid: true));
  }

  void resetPosition() {
    position = Vector2(game.width / 2, game.height * 0.95);
  }

  void move(Vector2 delta) {
    position.x = (position.x + delta.x)
        .clamp(game.paddleLength / 2, game.width - game.paddleLength / 2);
  }
}
