## Base state machine for handling changing states
## Handles AnimationState
class_name AnimationStateMachine
extends Node

@export var starting_state: AnimationState;
var current_state: AnimationState;

# --If using an inherited class, call that class' respective init fn--
func init(parent: Node2D, animations: AnimatedSprite2D) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
	
	change_state(starting_state)

func change_state(new_state: AnimationState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	print(current_state.name)
