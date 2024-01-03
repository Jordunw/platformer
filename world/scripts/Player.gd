extends CharacterBody2D

var movementState : PlayerMovementState = PlayerMovementState.new();

func _ready():
	add_child(movementState);
	var sprite : AnimatedSprite2D = get_child(0) as AnimatedSprite2D;
	sprite.play();

func _physics_process(delta):
	var desiredMovement = movementState.update(delta, is_on_floor());
	var collision: KinematicCollision2D = move_and_collide(desiredMovement);
	if collision:
		movementState.handleCollision(collision);
	
