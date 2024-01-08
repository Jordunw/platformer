class_name PlayerMovementState extends Node

var velocity = Vector2.ZERO
var velocityNorm = velocity.normalized()

var MAX_SPEED = 200
var ACCELERATION = 500
var AIR_ACCELERATION = 200
var JUMP_VELOCITY = -5000
var GRAVITY = 20;

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
	return velocity

func calculateMovement(delta: float):
	var inputDir = Vector2.RIGHT if Input.is_action_pressed("move_right") \
		else Vector2.LEFT if Input.is_action_pressed("move_left") \
		else Vector2.ZERO
	
	if Input.is_action_just_pressed("jump") and isOnFloor:
			velocity.y += JUMP_VELOCITY;
	
	if Input.is_action_just_pressed("move_dash") and !isDashing:
		startDash(inputDir)

	if isDashing:
		handleDash(delta)
		
	velocity *= delta
	resetCollisionFlags()

# calculates collision physics for a single collision
# this is called multiple times each tick, where new movement and collisions are calculated based on delta
func subTickCollisionUpdate(normal: Vector2) -> Vector2:
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
	var friction = 0.5 if isOnFloor else 0.2
	velocity.x = lerp(0.0, friction * delta, velocity.x)

func applyGravity(delta: float):
	if !isOnFloor:
		velocity.y += GRAVITY * delta * 1.0 if velocityNorm.y < 0 else 2.0  # Some gravity value

func resetCollisionFlags():
	isOnCeiling = false
	isOnFloor = false
	isOnLeftWall = false
	isOnRightWall = false

func isOnWall() -> bool:
	return isOnLeftWall || isOnRightWall
