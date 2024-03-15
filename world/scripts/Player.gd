extends CharacterBody2D

@onready var tilemap: TileMap = $"../test_world"
@onready var movementStateMachine: MovementStateMachine = $"StateMachine"
@onready var moveComponent: PlayerMoveComponent = $"MoveComponent"

var raycasts: Array = [RayCast2D.new(), RayCast2D.new(), RayCast2D.new(), RayCast2D.new()]

func _ready():
	var sprite: AnimatedSprite2D = get_child(0) as AnimatedSprite2D
	movementStateMachine.init_msm(self, sprite, moveComponent)

func _unhandled_input(event):
	movementStateMachine.process_input(event)

func _physics_process(delta):
	movementStateMachine.process_physics(delta)

func _process(delta):
	moveComponent.process_frame(delta)
	movementStateMachine.process_frame(delta)

func get_collision_norm() -> Vector2:
	return get_last_slide_collision().get_normal()
