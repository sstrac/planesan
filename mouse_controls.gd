extends Node2D


var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for mouse_sprite in get_children().slice(0,2):
		mouse_sprite.show()
		await get_tree().create_timer(5).timeout
		mouse_sprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hidden:
		show()


func _on_area_2d_area_entered(area: Area2D) -> void:
	LevelTracker.all_controls_shown = true
	var mouse_sprite = get_children()[2]
	mouse_sprite.show()
	await get_tree().create_timer(5).timeout
	mouse_sprite.hide()
	queue_free()
