import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:holiday_break_hackaton/main.dart';

final class Paddle extends RectangleComponent
    with HasGameReference<BrickBreakerGame> {
  Paddle({required super.size})
      : super(
          paint: BasicPalette.green.paint(),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
