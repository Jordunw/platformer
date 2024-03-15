## Base class for a movement state (and animation state)
## Defines basic functions for movement

class_name MovementState
extends AnimationState

@export var move_speed: float = 400
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_component

func process_input(event: InputEvent) -> MovementState:
	return null

func process_frame(delta: float) -> MovementState:
	return null
	
func process_physics(delta: float) -> MovementState:
	return null
	
func get_movement_input() -> Vector2:
	return move_component.get_movement_direction()
	
func get_jump() -> bool:
	return move_component.wants_jump()

func get_sprint() -> bool:
	return move_component.wants_sprint()
	
func get_crouch() -> bool:
	return move_component.wants_crouch()

func get_dash() -> bool:
	return move_component.wants_dash()
	
func is_on_wall() -> bool:
	return parent.is_on_wall()

func is_on_floor() -> bool:
	return parent.is_on_floor()
	
func is_on_ceil() -> bool:
	return parent.is_on_ceiling()

func get_grappling() -> bool:
	return is_on_wall() && ceili(get_movement_input().x) ^ ceili(parent.get_collision_norm().x) < 0

# faster version that avoids second calculation if possible
func get_not_grappling() -> bool:
	return !is_on_wall() || !(ceili(get_movement_input().x) ^ ceili(parent.get_collision_norm().x)) < 0
