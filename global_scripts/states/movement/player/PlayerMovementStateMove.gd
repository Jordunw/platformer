## Player moving state (not sprinting)
class_name PlayerMovementStateMove
extends MovementState

@export_category("MovementStates")
@export var dash_state: MovementState # on dash
@export var fall_state: MovementState # on walks off edge
@export var idle_state: MovementState # on velocity = 0 && no input
@export var jump_state: MovementState # on jump
@export var crouch_state: MovementState # on crouch
@export var sprint_state: MovementState # on sprint

@export_category("Movement")

func process_input(event: InputEvent) -> MovementState:
	if get_dash():
		return dash_state
	return null
	
func process_physics(delta: float) -> MovementState:
	if get_jump() && parent.is_on_floor():
		return jump_state
	
	parent.velocity.y += gravity * delta;
	
	var movementX = get_movement_input().x * move_speed
	
	if movementX == 0.0:
		return idle_state
	
	animations.flip_h = movementX < 0
	parent.velocity.x = movementX
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null	 
