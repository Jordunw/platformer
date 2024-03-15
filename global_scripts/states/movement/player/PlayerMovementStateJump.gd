extends MovementState

@export_category("MovementStates")
@export var fall_state: MovementState # on velocity > 0
@export var idle_state: MovementState # on lands at apex/incline w/ no input
@export var move_state: MovementState # on lands at apex/incline w/ standard input
@export var dash_state: MovementState # on dash
@export var slide_state: MovementState # on lands at apex/incline w/ enough velocity + input for slide
@export var crouch_state: MovementState # on lands at apex/incline w/ crouch
@export var grapple_state: MovementState # on hits wall and inputs to grapple
@export var sprint_state: MovementState # on lands at apex/incline w/ sprint input

@export_category("Movement")
@export var jump_force: float = 900.0
@export var air_resistance_multi: float = .8 # moves slightly slower in air

func enter() -> void:
	super()
	parent.velocity.y = -jump_force
	
func process_physics(delta: float) -> MovementState:
	if get_dash():
		return dash_state
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movementX = get_movement_input().x * move_speed * air_resistance_multi
	
	if movementX != 0:
		animations.flip_h = movementX < 0
	parent.velocity.x = movementX
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movementX != 0:
			if Input.is_action_pressed("move_crouch"):
				return slide_state
			return move_state
		if Input.is_action_pressed("move_crouch"):
			return crouch_state
		return idle_state
		
	return null
