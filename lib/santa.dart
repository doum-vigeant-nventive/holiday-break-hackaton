import 'package:flame/components.dart';
import 'package:holiday_break_hackaton/brick_breaker_game.dart';

final class Santa extends SpriteComponent
    with HasGameReference<BrickBreakerGame> {
  Santa({required super.position, required Vector2 size})
      : super(size: size, anchor: Anchor.topCenter);

  final double speed = 450; // Movement speed in pixels per second
  final Vector2 target = Vector2(400.0, 600.0);

  Vector2? targetPosition; // The position to move towards
  Vector2? _direction; // Direction of movement

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Idle (2).png');
  }

  void animateDescent() {
    targetPosition = target;
    _direction = (target - position).normalized(); // Calculate direction
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If no target position is set, remain stationary
    if (targetPosition == null || _direction == null) return;

    // Calculate movement
    final movement = _direction! * speed * dt;

    // Move towards the target, but stop if within a small distance
    if ((targetPosition! - position).length < movement.length) {
      position.setFrom(targetPosition!);
      targetPosition = null; // Stop animation
      _direction = null; // Clear direction
    } else {
      position.add(movement);
    }
  }

  void resetPosition(Vector2 newPosition) {
    position.setFrom(newPosition);
  }
}
