extends MovementState

@export_category("MovementStates")
@export var dash_state: MovementState # on dashes out of grapple
@export var fall_state: MovementState # on lets go of grapple
@export var jump_state: MovementState # on jumps out of grapple

@export_category("Movement")
@export var SLIDE_SPEED: int = 100 # speed at which the player will slide down a wall while grappling
@export var SLIDE_DELAY: float = .5 # time delay before player starts sliding down a wall
var slide_timer: float = .0
@export var COYOTE_TIME: float = .1 # time player has to jump after releasing input
var coyote_timer: float = .0

var is_grappling: bool = true

func enter() -> void:
	is_grappling = true
	slide_timer = SLIDE_DELAY

func process_input(event: InputEvent) -> MovementState:
	return null
	
func process_physics(delta: float) -> MovementState:
	if get_dash():
		return dash_state
	
	if get_not_grappling():
		# give the player a few milliseconds to make a jump first
		if is_grappling:
			is_grappling = false # unset value to mark start of coyote time
			coyote_timer = COYOTE_TIME
		else:
			coyote_timer = clampf(coyote_timer - delta, 0.0, COYOTE_TIME)
			if coyote_timer == 0.0: # timer has run out, no jump detected, start falling
				return fall_state
			if get_jump():
				return jump_state
		return null
	
	slide_timer = clampf(slide_timer - delta, 0.0, SLIDE_DELAY)
	if slide_timer == 0.0:
		parent.velocity.y = SLIDE_SPEED
	
	is_grappling = true
	return null
