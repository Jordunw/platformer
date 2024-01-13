class_name PlayerMovementState extends Node

var velocity = Vector2.ZERO
var velocityNorm = velocity.normalized()
var inputDir = Vector2.ZERO

var WALK_VELOCITY = 200
var RUN_VELOCITY = 300
var ACCELERATION = 500
var AIR_ACCELERATION = 200
var JUMP_VELOCITY = -100
var GRAVITY = 5000;

var DASH_VELOCITY = 500
var DASH_DURATION = 0.2

var dashDirection = Vector2.ZERO
var dashTimer = 0.0
var isDashing = false

var isOnCeiling = false
var isOnFloor = false
var isOnLeftWall = false
var isOnRightWall = false

func update(delta: float) -> Vector2:
	calculateMovement(delta)
	applyFriction(delta)
	applyGravity(delta)
	return velocity * delta;

func calculateMovement(delta: float):
	inputDir = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	if(Input.is_action_pressed("move_sprint")):
		velocity.x = RUN_VELOCITY * inputDir.x;
	else:
		velocity.x = WALK_VELOCITY * inputDir.x;
	
	if Input.is_action_just_pressed("jump") and isOnFloor:
			velocity.y += JUMP_VELOCITY;
	
	if Input.is_action_just_pressed("move_dash") and !isDashing:
		startDash(inputDir)

	if isDashing:
		handleDash(delta)

# calculates collision physics for a single collision
# this is called multiple times each tick, where new movement and collisions are calculated based on delta
func subTickCollisionUpdate(normal: Vector2) -> Vector2:
	resetCollisionFlags()
	# handle vertical/horizontal collisions
	if normal.x == 0.0 && normal.y != 0.0:
		velocity.y = 0.0
		if normal.y > 0.0:
			isOnCeiling = true
		else:
			isOnFloor = true

	elif normal.y == 0.0 && normal.x != 0.0:
		velocity.x = 0.0
		if normal.x > 0.0:
			isOnLeftWall = true
		else:
			isOnRightWall = true
	
	# handle angled collisions
	else:
		# get the reflection based on the normal
		velocity -= 2 * velocity.dot(normal) * normal

	return velocity

func startDash(direction: Vector2):
	if direction != Vector2.ZERO:
		isDashing = true
		dashDirection = direction.normalized()
		velocity = dashDirection * DASH_VELOCITY
		dashTimer = DASH_DURATION

func handleDash(delta: float):
	dashTimer -= delta
	if dashTimer <= 0:
		isDashing = false

func applyFriction(delta: float):
	var friction = 0.1 if isOnFloor else 0.04
	velocity.x = lerp(0.0, friction * delta, velocity.x)

func applyGravity(delta: float):
	if !isOnFloor:
		if velocity.y > 0.0:
			velocity.y += GRAVITY * delta * 2
		else:
			velocity.y += GRAVITY * delta

func resetCollisionFlags():
	isOnCeiling = false
	isOnFloor = false
	isOnLeftWall = false
	isOnRightWall = false

func isOnWall() -> bool:
	return isOnLeftWall || isOnRightWall
