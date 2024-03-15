## Idle player state

extends MovementState

@export_category("MovementStates")
@export var dash_state: MovementState # on dash
@export var fall_state: MovementState # on block below disappears
@export var move_state: MovementState # on move
@export var jump_state: MovementState # on jump
@export var sprint_state: MovementState # on sprint
@export var crouch_state: MovementState # on crouch

@export_category("Movement")

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> MovementState:
	if get_jump() && parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("move_dash"):
		return dash_state
	if get_movement_input() != Vector2.ZERO:
		return move_state
	return null
	
func process_physics(delta: float) -> MovementState:
	parent.velocity.y += gravity * delta * (2 if parent.velocity.y > 0 else 1)
	parent.move_and_slide()
	
	if !parent.is_on_floor() && parent.velocity.y > 0:
		return fall_state
	return null
