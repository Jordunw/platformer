extends Node2D

@onready var map1 = load("res://world/scenes/World1.tscn").instantiate();
@onready var map2 = load("res://world/scenes/World2.tscn").instantiate();

var map_no = 1;

var portal : Rect2i = Rect2i(Vector2(73,-1), Vector2(2,4));
var player : CharacterBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player") as CharacterBody2D;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
