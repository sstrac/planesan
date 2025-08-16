extends Node


const LEVEL_1 = "res://level/level_1.tscn"
const LEVEL_2 = "res://level/level_2.tscn"

var plane
var retry_times = 0
var current_level = 1
var level_1_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_level_to(level: int):
	current_level = level
	var level_scene: String
	
	match level:
		1: level_scene = LEVEL_1
		2: level_scene = LEVEL_2
		
	get_tree().change_scene_to_file(level_scene)
