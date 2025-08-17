extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	LevelTracker.plane = get_node("Plane")

	if LevelTracker.all_controls_shown:
		get_node("CanvasLayer/MouseControls").queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
