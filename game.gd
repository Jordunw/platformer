extends Node2D

# code is altered from here:
# https://www.youtube.com/watch?v=_MBlWKP9HCE&t=418s&ab_channel=EchoinaVoid

@export var default_scale: float = 2.5
@export var zoom_scale: float = default_scale

@onready var MainVPC: SubViewportContainer = $SubViewportContainer


func _ready():
	#MainVPC.scale = Vector2(default_scale, default_scale)
	set_zoom(zoom_scale)
	$GUI/ZoomLabel.text = "Zoom: " + str(zoom_scale)

	
func _process(_delta):
	if Input.is_action_just_released("zoom_in"):
		zoom_scale *= 2
		set_zoom(zoom_scale)
		
	if Input.is_action_just_released("zoom_out"):
		zoom_scale /= 2
		set_zoom(zoom_scale)


func set_zoom(zoom_scale) -> void:
	#MainVPC.scale = Vector2(zoom_scale, zoom_scale)
	#MainVPC.position = calculate_new_position(zoom_scale)
	
	$GUI/ZoomLabel.text = "Zoom: " + str(zoom_scale)
	
	var tween: Tween = create_tween()
	tween.stop()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(
		MainVPC,
		"scale",
		Vector2(zoom_scale, zoom_scale),
		0.1
	)
	tween.tween_property(
		MainVPC,
		"position",
		calculate_new_position(zoom_scale),
		0.1
	)
	tween.play()
	await tween.finished


func calculate_new_position(zoom_scale) -> Vector2:
	
	var window_size :Vector2 = Vector2(
		ProjectSettings.get("display/window/size/viewport_width"),
		ProjectSettings.get("display/window/size/viewport_height")
	)
		
	var new_position :Vector2 = (((window_size * zoom_scale) / (2.0 * default_scale)) - window_size)
	
	# idk why this is needed, probably some change between godot 3.5 -> 4
	new_position -= window_size * (zoom_scale * 7.0/10.0 - 3.0/2.0)
	#new_position -= window_size * (zoom_scale * 2.0/5.0 - 3.0/2.0)
	
	return new_position
