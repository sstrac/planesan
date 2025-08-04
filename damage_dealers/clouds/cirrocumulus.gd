extends Node2D

const MEANDER_LIMIT = 5
@onready var timer: Timer = get_node("Timer")

var original_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_meander)
	original_pos = position


func _meander():
	var x = [-1, 0, 1].pick_random()
	var y = [-1, 0, 1].pick_random()
	
	if position.x + x < original_pos.x + MEANDER_LIMIT and position.x + x > original_pos.x - MEANDER_LIMIT:
		if position.y + y < original_pos.y + MEANDER_LIMIT and position.y + y > original_pos.y - MEANDER_LIMIT:
			position += Vector2(x, y)
	
	timer.start()
	timer.wait_time = randf_range(1,3)
