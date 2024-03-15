class_name MovementStateMachine
extends AnimationStateMachine

# if using this class, do NOT call the init() function!!!
func init_msm(parent: Node2D, animations: AnimatedSprite2D, move_component) -> void:
	super.init(parent, animations)
	for child in get_children():
		child.move_component = move_component

	# Initialize to the default state
	change_state(starting_state)

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
