extends Node


var plane
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plane = get_tree().get_nodes_in_group('plane')[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
