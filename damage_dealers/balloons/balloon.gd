extends Path2D


@onready var follow: PathFollow2D = get_node("PathFollow2D")

var position_reset: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow.progress_ratio += delta * 0.1
		
	if follow.progress_ratio > 0.9 and not position_reset:
		global_position = follow.global_position
		position_reset = true
		follow.progress_ratio = 0
		
	elif follow.progress_ratio < 0.9:
		position_reset = false
