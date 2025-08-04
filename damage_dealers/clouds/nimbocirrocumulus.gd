extends Node2D

const MEANDER_LIMIT = 6
const ATTRACTION_SPEED = 3

@onready var timer: Timer = get_node("Timer")

var original_pos
var attracted_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_meander)
	original_pos = position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attracted_node:
		global_position = global_position.move_toward(attracted_node.global_position, delta * ATTRACTION_SPEED)


func _meander():
	if not attracted_node:
		var x = [-1, 0, 1].pick_random()
		var y = [-1, 0, 1].pick_random()
		
		if position.x + x < original_pos.x + MEANDER_LIMIT and position.x + x > original_pos.x - MEANDER_LIMIT:
			if position.y + y < original_pos.y + MEANDER_LIMIT and position.y + y > original_pos.y - MEANDER_LIMIT:
				position += Vector2(x, y)
		timer.start()
		timer.wait_time = randf_range(1,3)
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	attracted_node = area.get_parent()


func _on_area_2d_area_exited(area: Area2D) -> void:
	attracted_node = null
