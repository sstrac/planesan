extends TextureButton


func _on_button_down() -> void:
	KeySounds.key_down()
	LevelTracker.retry_times += 1
	get_tree().reload_current_scene()


func _process(delta: float) -> void:
	disabled = false


func _on_button_up() -> void:
	KeySounds.key_up()
