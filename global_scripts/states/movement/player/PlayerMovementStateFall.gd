extends MovementState

@export_category("MovementStates")
@export var idle_state: MovementState # on falls into no input
@export var move_state: MovementState # on falls into standard movement
@export var slide_state: MovementState # on falls onto angled surface w/ slide input
@export var crouch_state: MovementState # on falls into crouch
@export var sprint_state: MovementState # on falls into sprint
@export var jump_state: MovementState # on falls into jump input
@export var grapple_state: MovementState # on falls into wall & grapples
@export var dash_state: MovementState # on dash

@export_category("Movement")
@export var air_resistance_multi: float = .8 # reduce movement speed while in air
@export var FALL_SPEED_MULTI: float = 1.75
@export var MAX_FALL_SPEED: int = 750

func process_physics(delta: float) -> MovementState:
	if get_dash():
		return dash_state
		
	parent.velocity.y = clamp(parent.velocity.y + gravity * FALL_SPEED_MULTI * delta, 0.0, MAX_FALL_SPEED)
	var movementX = get_movement_input().x * move_speed * air_resistance_multi
	
	if movementX != 0:
		animations.flip_h = movementX < 0
	parent.velocity.x = movementX
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movementX != 0:
			if get_crouch():
				return slide_state
			return move_state
		if get_crouch():
			return crouch_state
		return idle_state
	if get_grappling():
		return grapple_state
	return null
