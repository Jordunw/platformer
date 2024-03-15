## Base state for any animated node
## Handles only animation. See inherited states

class_name AnimationState
extends Node

@export var animation_name: String

var animations: AnimatedSprite2D
var parent: Node2D # can be attached to any Node2D node

func enter() -> void:
	animations.play(animation_name)
	
func exit() -> void:
	pass
