extends AnimatedSprite2D

const CIRRUS_CLUSTER = preload("res://damage_dealers/clouds/cirrus_cluster.tscn")
		
@export var is_objective: bool
@export var x_speed: float = 1

@onready var obj_manager = get_node("ObjectiveManager")
# Called when the node enters the scene tree for the first time.
var i = 0

func _ready() -> void:
	if is_objective:
		obj_manager.activate_objective_collision_layer()
		obj_manager.set_objective()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame == 0:
		i += delta * 5
	
	if i >= 3:
		var cirrus = CIRRUS_CLUSTER.instantiate()
		add_child(cirrus)
		cirrus.position -= Vector2(50, 16)
		i = 0
	
