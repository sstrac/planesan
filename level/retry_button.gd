extends TextureButton


func _on_button_down() -> void:
	get_tree().current_scene.queue_free()
	RetryTracker.clear_groups()
	var level1 = load("res://level/level_1.tscn").instantiate()
	get_tree().root.add_child(level1)
	PlaneTracker.plane = level1.get_node('Plane')
	get_tree().current_scene = level1
