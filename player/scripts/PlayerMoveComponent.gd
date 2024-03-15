## Movement component for the player
## Defines basic movement inputs
## Handles some minor qol stuff like jump input buffering
class_name PlayerMoveComponent
extends Node

# length of time in seconds for input buffer
@export var JUMP_INPUT_BUFFER: float = .1
var jump_buffer_timer: float = .0

# dash cooldown in seconds
@export var DASH_COOLDOWN: float = 1.5
var dash_cooldown_timer: float = .0

func process_frame(delta):
	jump_buffer_timer = clampf(jump_buffer_timer - delta, 0.0, JUMP_INPUT_BUFFER)
	dash_cooldown_timer = clampf(dash_cooldown_timer - delta, 0.0, DASH_COOLDOWN)

# wasd movement
func get_movement_direction() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

func wants_jump() -> bool:
	# autojump if buffer timer > 0
	if jump_buffer_timer > 0.0:
		return true
	# otherwise, check if player is attempting to jump
	# on first press, reset jump buffer timer (for single press)
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = .15
		return true
	# dont set jump buffer timer if holding down, but attempt to jump
	if Input.is_action_pressed("jump"):
		return true
	# not jumping
	return false	
	
func wants_dash() -> bool:
	if Input.is_action_just_pressed("move_dash") && dash_cooldown_timer == 0.0:
		dash_cooldown_timer = DASH_COOLDOWN
		return true
	return false

func wants_crouch() -> bool:
	# could add setting for crouch hold/toggle
	return Input.is_action_just_pressed("crouch")
	
func wants_sprint() -> bool:
	# could add setting for sprint hold/toggle
	return Input.is_action_pressed("move_sprint")

# Should be called when the player successfully jumps
# to avoid extra unwanted jump inputs
func reset_jump_buffer_timer() -> void:
	jump_buffer_timer = .0
