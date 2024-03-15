extends MovementState

@export_category("MovementStates")
@export var slide_state: MovementState
@export var dash_state: MovementState
@export var fall_state: MovementState
@export var jump_state: MovementState
@export var idle_state: MovementState
@export var move_state: MovementState

@export_category("Movement")

func process_input(event: InputEvent) -> MovementState:
	return null
	
func process_physics(delta: float) -> MovementState:
	return null
