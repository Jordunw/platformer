extends Node2D

var bullet_casing_scene: PackedScene = preload("res://particles/scenes/bullet_casing.tscn")

func _on_player_shoot(casing_position, casing_velocity):
	#for i in range(100):
	var bullet_casing = bullet_casing_scene.instantiate() as RigidBody2D
	bullet_casing.position = casing_position
	bullet_casing.linear_velocity = casing_velocity
	bullet_casing.angular_velocity = 10
	$Particles.add_child(bullet_casing)
