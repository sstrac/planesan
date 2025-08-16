extends Path2D

@export var is_objective: bool = true
@export var path_start_ratio: float = 0
@onready var follow: PathFollow2D = get_node("PathFollow2D")
@onready var obj_manager = get_node("PathFollow2D/ObjectiveManager")

var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	follow.progress_ratio = path_start_ratio
	if is_objective:
		obj_manager.activate_objective_collision_layer()
		obj_manager.set_objective()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow.progress_ratio >= 0.9:
		dir = -1
	elif follow.progress_ratio <= 0.1:
		dir = 1
	
	follow.progress_ratio = follow.progress_ratio + dir * delta * 0.4
