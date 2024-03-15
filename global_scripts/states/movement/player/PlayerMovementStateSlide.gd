extends MovementState

@export_category("MovementStates")
@export var dash_state: MovementState # on dash
@export var fall_state: MovementState # on slides off edge
@export var jump_state: MovementState # on jump
@export var idle_state: MovementState # on slows to velocity = 0 and uncrouch simultaneously
@export var crouch_state: MovementState # on slows to velocity = 0
@export var move_state: MovementState # on uncrouches while sliding
@export var sprint_state: MovementState # on uncrouches + sprint input while sliding

@export_category("Movement")

func process_input(event: InputEvent) -> MovementState:
	return null
	
func process_physics(delta: float) -> MovementState:
	return null
