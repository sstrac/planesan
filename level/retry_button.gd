extends TextureButton


func _on_button_down() -> void:
	LevelTracker.retry_times += 1
	get_tree().reload_current_scene()
