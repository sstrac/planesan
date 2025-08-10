extends Path2D

@export var is_objective: bool
@export var texture: Texture2D

@onready var follow: PathFollow2D = get_node("PathFollow2D")
@onready var objective_manager = get_node("PathFollow2D/ObjectiveManager")

var position_reset: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if texture:
		get_node("PathFollow2D/Sprite2D").set_texture(texture)
		objective_manager.texture = texture

	if is_objective:
		objective_manager.set_objective()
		objective_manager.activate_objective_collision_layer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow.progress_ratio += delta * 0.1
		
	if follow.progress_ratio > 0.9 and not position_reset:
		global_position = follow.global_position
		position_reset = true
		follow.progress_ratio = 0
		
	elif follow.progress_ratio < 0.9:
		position_reset = false
