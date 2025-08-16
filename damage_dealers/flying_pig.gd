extends "res://damage_dealers/clouds/cloud.gd"

@export var is_objective: bool

@onready var obj_manager = get_node("ObjectiveManager")
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if is_objective:
		obj_manager.activate_objective_collision_layer()
		obj_manager.set_objective()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
