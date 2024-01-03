extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -350.0

signal shoot(casing_position, casing_velocity)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# keeps angle between 0 and 2 * PI
func boundAngle(angle):
	if (angle > PI * 2):
		return angle - PI * 2
		
	if (angle < 0):
		return angle + PI * 2
		
	return angle


func _ready():
	var sprite: AnimatedSprite2D = get_child(0) as AnimatedSprite2D;
	sprite.play();
	
func _process(_delta):
	
	var gun_image = $GunImage
	gun_image.look_at(get_global_mouse_position())
	
	# flip the gun sprite so it's not upside down when pointing left
	gun_image.rotation = boundAngle(gun_image.rotation)
	var flipped: bool = (gun_image.rotation > PI / 2 and gun_image.rotation < 3 * PI / 2)
	gun_image.flip_v = flipped
	
	if velocity.x == 0:
		$Sprite2D.play("idle")
		
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.play("running")
		
	else:
		$Sprite2D.flip_h = true
		$Sprite2D.play("running")
		
	if Input.is_action_just_pressed("shoot"):
		var casing_point: Vector2 = $GunImage/CasingEjectionPoint.global_position
		
		var y_direction: int = -1 if flipped else 1
		var casing_velocity = Vector2(-150, -150 * y_direction).rotated($GunImage.rotation)
		
		shoot.emit(casing_point, casing_velocity)



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
	
	move_and_slide()
