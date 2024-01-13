extends CharacterBody2D

@onready var tilemap: TileMap = $"../test_world";

var movementState: PlayerMovementState = PlayerMovementState.new();
var raycasts: Array = [RayCast2D.new(), RayCast2D.new(), RayCast2D.new(), RayCast2D.new()];

signal wall_collision

func _ready():
	add_child(movementState);
	var sprite: AnimatedSprite2D = get_child(0) as AnimatedSprite2D;
	sprite.play();


func _physics_process(delta):
	var desiredMovement: Vector2 = movementState.update(delta);
	var collision = move_and_collide(desiredMovement);
	while collision != null:
		# If colliding with the tilemap:
		if collision.get_collider() is TileMap:
			var normal: Vector2 = collision.get_normal();
			#var collisionPos: Vector2 = collision.get_position();
			var remainingMovement: Vector2 = collision.get_remainder();

			# broadcast collision event
			# on collision event: stop dash, update state, run particle effects/animations, etc.
			emit_signal("wall_collision", movementState.velocity);

			# add ray casts to handle cases where player hits edge
			# get vert&horiz movement from velocity vector
			# cast rays on 1-2 sides based on player movement (e.g. if moving NE cast rays right and up)
			# adjust in both directions (may need to prioritize one over the other)

			
			# recalculate velocity on collision
			var newDesiredMovement = movementState.subTickCollisionUpdate(normal);
			
			
			# calculate new intermediate delta based on distance traveled vs intended distance over this delta
			var remainingMovementRatio: float = remainingMovement.length_squared() / desiredMovement.length_squared();
			delta *= (1 - remainingMovementRatio);
			
			# update position, desiredMovement and check for a new collision
			desiredMovement = newDesiredMovement;
			collision = move_and_collide(desiredMovement * delta);

		else: # colliding with anything other than the tilemap
			pass
