extends TextureButton


func _ready():
	set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)


func _process(delta: float) -> void:
	disabled = false
