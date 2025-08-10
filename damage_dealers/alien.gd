extends Node2D


@export var activation_min_pos: Vector2
@export var activation_max_pos: Vector2

@onready var alien = get_node("Sprite2D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var plane_pos = PlaneTracker.plane.global_position
	var within_min_y = plane_pos.y > activation_min_pos.y
	var within_max_y = plane_pos.y < activation_max_pos.y
	var within_min_x = plane_pos.x > activation_min_pos.x
	var within_max_x = plane_pos.x < activation_max_pos.x
	if within_min_y and within_max_y and within_min_x and within_max_x:
		var dir_to_alien = sign(global_position.direction_to(alien.global_position))
		var new_center_pos = lerp(global_position, plane_pos, delta)
		if sign(new_center_pos.x) != dir_to_alien.x:
			global_position = Vector2(global_position.x, new_center_pos.y)
		if sign(new_center_pos.y) != dir_to_alien.y:
			global_position = Vector2(new_center_pos.x, global_position.y)
		else:
			global_position = Vector2(new_center_pos.x + delta * 10, new_center_pos.y)
		
