extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	var tree = get_tree()
	tree.paused = false
	hide()
	
	LevelTracker.find_current_plane()
	
	if LevelTracker.retry_times > 0:
		tree.get_nodes_in_group('mouse_controls')[0].queue_free()
