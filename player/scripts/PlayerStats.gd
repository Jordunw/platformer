extends Node

# Player stats singleton class

@export_category("Battle Stats")
@export var max_health : int;
var health : int;	# current health
@export var defense : int;
@export var attack : int;	

@export_category("Movement Stats")
@export var horizontal_speed : float;	# side to side movement speed
@export var jump_height : float;		# jump height multiplier
@export var gravity_mod : float;		# player gravity multiplier

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Deal damage to the player
# Damage is calculated based on opponent attack and player defense
# returns if player has reached 0 health
func receive_damage(opp_attack : int) -> bool:
	var dmg = opp_attack - defense;
	health = clamp(health - dmg, 0, health)
	return false;
	
# Heal the player
# Will cap at max_health+overheal
# Returns total heal amount (e.g. health 1/5 healed 10 returns 4)
func heal(base_heal : int, overheal : int = 0) -> int:
	var total = min(max_health - health, base_heal) + overheal;
	health = clamp(health + base_heal, 0, max_health) + overheal;
	return total;
	
# Calculate damage dealt to an enemy
# Calculated based on player attack and opponent defense
# Returns total damage to be inflicted
func inflict_damage(opp_defense : int) -> int:
	return 0;
	
