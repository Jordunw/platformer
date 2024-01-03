extends CharacterBody2D

@onready var tilemap = $"../test_world";

var movementState : PlayerMovementState = PlayerMovementState.new();
var raycasts : Array = [RayCast2D.new(), RayCast2D.new(), RayCast2D.new(), RayCast2D.new()]

func _ready():
	add_child(movementState);
	var sprite : AnimatedSprite2D = get_child(0) as AnimatedSprite2D;
	sprite.play();
	for raycast in raycasts:
		add_child(raycast);

func _physics_process(delta):
	# basic collision handling example
	var desiredMovement = movementState.update(delta);
	
	# add ray casts to handle cases where player hits edge
	# raycasts are based on movement direction
	var perp_velocity : Vector2 = Vector2(desiredMovement.y, -desiredMovement.x);
	var perp_velocity_norm : Vector2 = perp_velocity.normalized();
	const raycast_spread : float = 1.25;
	
	for i in raycasts.size():
		var raycast: RayCast2D = raycasts[i];
		raycast.position = position + perp_velocity_norm * raycast_spread * (i-2);
		raycast.look_at(position + desiredMovement);
		raycast.force_raycast_update()
	
	if raycasts[0].is_colliding() and not raycasts[1].is_colliding()\
		and not raycasts[2].is_colliding() and not raycasts[3].is_colliding():
		position = raycasts[1].position;
		desiredMovement *= .95; # slightly reduce movement speed
	elif raycasts[3].is_colliding() and not raycasts[2].is_colliding()\
		and not raycasts[1].is_colliding() and not raycasts[0].is_colliding():
		position = raycasts[2].position;
		desiredMovement *= .95; # slightly reduce movement speed
		
	var collision: KinematicCollision2D = move_and_collide(desiredMovement);
	if collision:
		movementState.handleCollision(tilemap, collision, position, delta);
