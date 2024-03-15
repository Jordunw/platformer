# Player dashing state
extends MovementState

# accessible states from dash
@export_category("MovementStates")
@export var fall_state: MovementState # on dashes into air
@export var move_state: MovementState # on dashes into standard movement
@export var idle_state: MovementState # on dashes with no continued input
@export var sprint_state: MovementState # on dashes into sprint
@export var slide_state: MovementState # on dashes into slide
@export var grapple_state: MovementState # on dashes into grapple
# could add crouch as well

@export_category("Movement")
@export var DASH_FORCE: float = 1500.0
@export var DASH_REDUCTION_START_TIME = .2
@export var DASH_REDUCTION_FACTOR: float = 2.0
# length of dash in seconds
# note that the reduction factor is calculated based on a value of .7
# so that the final velocity after a dash will be 1/2 of the DASH_FORCE
@export var DASH_TIME: float = .7 
var dash_timer: float = .0

func enter() -> void:
	super()
	dash_timer = DASH_TIME
	# right now we are overwriting velocity with the dash
	# need to discuss how this should work
	parent.velocity = get_movement_input().normalized() * DASH_FORCE

func process_input(event: InputEvent) -> MovementState:
	# while in dash state, the player cannot move
	return null
	
func process_physics(delta: float) -> MovementState:
	# update timer (and state if necessary)
	dash_timer = clamp(dash_timer - delta, 0.0, DASH_TIME)
	# if no longer dashing
	if dash_timer <= 0:
		if get_grappling():
			return grapple_state
		if !parent.is_on_floor():
			return fall_state
		# else on the ground
		# not moving
		if get_movement_input() == Vector2.ZERO:
			return idle_state
		# moving
		if get_sprint():
			if get_crouch():
				return slide_state
			return sprint_state
		return move_state
		# while in dash state, only collision and friction are applied
		
	# if still dashing, reduce velocity based on (f(t)=1-6t^7)
	
	# if nearing end of dash, start slowing down
	if dash_timer <= .2:
		var reduction_factor: Vector2 = Vector2(1 - delta * DASH_REDUCTION_FACTOR, 1 - delta * DASH_REDUCTION_FACTOR)
		parent.velocity *= reduction_factor 
		
	parent.move_and_slide()
	
	return null
