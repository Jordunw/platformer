extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var sprite : AnimatedSprite2D = get_child(0) as AnimatedSprite2D;
	sprite.play();

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = -Input.get_action_strength("move_left") * SPEED + Input.get_action_strength("move_right") * SPEED;
	
	if velocity.x == 0:
		$Sprite2D.play("idle")
		
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.play("running")
		
	else:
		$Sprite2D.flip_h = true
		$Sprite2D.play("running")
		

	move_and_slide()
