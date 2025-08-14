extends Node

var plane
var retry_times = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_current_plane()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func find_current_plane():
	plane = get_tree().get_nodes_in_group('plane').filter(func(c: Node): return !c.is_queued_for_deletion())[0]
	
