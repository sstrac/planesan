extends TextureButton


func _ready():
	set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)


func _process(delta: float) -> void:
	disabled = false


func _on_button_down() -> void:
	KeySounds.key_down()


func _on_button_up() -> void:
	KeySounds.key_up()
