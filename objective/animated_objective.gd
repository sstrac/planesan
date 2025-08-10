@tool
extends Sprite2D

@export var book: CanvasItem


func _process(delta: float) -> void:
	var dest = book.global_position + Vector2(3, 0)
	global_position = lerp(global_position, dest, delta * 5)
	if global_position.distance_to(dest) < 1:
		queue_free()
