## Crouching movement state - includes walking while crouching

extends MovementState

@export_category("MovementStates")
@export var move_state: MovementState # on uncrouch & moving
@export var jump_state: MovementState # on jump
@export var idle_state: MovementState # on uncrouch & not moving
@export var dash_state: MovementState # on dash
@export var sprint_state: MovementState # on sprint

@export_category("Movement")
@export var crouch_speed_multiplier: float = .6

func process_input(event: InputEvent) -> MovementState:
	if get_crouch():
		if get_movement_input() == Vector2.ZERO:
			return idle_state
		if get_sprint() == true:
			return sprint_state
		return move_state
	if get_dash():
		return dash_state
	if move_component.wants_jump():
		return jump_state
	return null
	
func process_physics(delta: float) -> MovementState:
	return null
