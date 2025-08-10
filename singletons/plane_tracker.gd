extends Node

const TARGET_CIRCLE_DIRECTIONS = [Vector2.ONE, Vector2(-1,1), -Vector2.ONE, Vector2(1,-1)]

var plane_circle_path_tracker = []
var i = 0

var plane
var prev_pos
var prev_dir

signal forward_circled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plane = get_tree().get_nodes_in_group('plane')[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if prev_pos:
		var dir = sign(prev_pos.direction_to(plane.position))
		if prev_dir:
			if TARGET_CIRCLE_DIRECTIONS.has(prev_dir):
				if prev_dir != dir:
					var next_dir_i = TARGET_CIRCLE_DIRECTIONS.find(prev_dir) + 1
					if TARGET_CIRCLE_DIRECTIONS.size() == next_dir_i:
						next_dir_i = 0
					
					if TARGET_CIRCLE_DIRECTIONS[next_dir_i] == dir:
						i += 1
					else:
						i = 0
				
		prev_dir = dir
	prev_pos = plane.position
	
	if i == 5:
		forward_circled.emit()
		i = 0
