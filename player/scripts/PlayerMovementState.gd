class_name PlayerMovementState extends Node;

var velocity = Vector2.ZERO
var maxSpeed = 200
var acceleration = 1000
var airAcceleration = 500
var jumpVelocity = -500
var dashVelocity = 1000
var dashDuration = 0.2
var isDashing = false
var dashDirection = Vector2.ZERO
var dashTimer = 0.0

func update(delta: float, isOnFloor: bool) -> Vector2:
	calculateMovement(delta, isOnFloor)
	applyFriction(delta, isOnFloor)
	applyGravity(delta, isOnFloor)
	return velocity;

func calculateMovement(delta: float, isOnFloor: bool):
	var inputDir = Vector2.RIGHT if Input.is_action_pressed("move_right") else Vector2.LEFT if Input.is_action_pressed("move_left") else Vector2.ZERO
	var desiredVel = inputDir * (dashVelocity if isDashing else (maxSpeed if isOnFloor else airAcceleration))
	
	velocity = velocity.lerp(desiredVel, acceleration * delta if isOnFloor else airAcceleration * delta)
	
	if Input.is_action_just_pressed("move_jump") and isOnFloor:
		velocity.y = jumpVelocity
	
	if Input.is_action_just_pressed("move_dash") and !isDashing:
		startDash(inputDir)

	if isDashing:
		handleDash(delta)

func startDash(direction: Vector2):
	if direction != Vector2.ZERO:
		isDashing = true
		dashDirection = direction.normalized()
		velocity = dashDirection * dashVelocity
		dashTimer = dashDuration

func handleDash(delta: float):
	dashTimer -= delta
	if dashTimer <= 0:
		isDashing = false

func applyFriction(delta: float, isOnFloor: bool):
	var friction = 0.5 if isOnFloor else 0.2
	velocity.x = lerp(0.0, friction * delta, velocity.x)

func applyGravity(delta: float, isOnFloor: bool):
	if isOnFloor:
		velocity.y += 30 * delta  # Some gravity value

func handleCollision(collision: KinematicCollision2D):
	var collider = collision.collider;
	var normal = collision.get_normal();
	if normal.x != 0:
		velocity.x = 0;
	if normal.y != 0:
		velocity.y = 0;
