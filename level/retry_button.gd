extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	get_tree().current_scene.queue_free()
	var level1 = load("res://level/level_1.tscn").instantiate()
	get_tree().root.add_child(level1)
	PlaneTracker.plane = level1.get_node('Plane')
	get_tree().current_scene = level1
