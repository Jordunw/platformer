extends RigidBody2D


# after 0.25 seconds, enable collisions with the player. This prevents the casing from 
# hitting the player immediately upon being fired

func _on_player_collision_timer_timeout():
	set_collision_mask_value(2, true)
