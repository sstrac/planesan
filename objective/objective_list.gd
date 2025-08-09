extends Control

var i = 0

var area_to_i = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ObjectiveTracker.found.connect(_on_objective_found)
	_set_objectives()


func _set_objectives():
	for objective: Area2D in get_tree().get_nodes_in_group('objective'):
		var parent = objective.get_parent()
		if parent.has_node("ObjectiveManager"):
			var obj_man_texture = parent.get_node("ObjectiveManager").texture
			if not get_children().map(func(n): return n.texture).has(obj_man_texture):
				get_children()[i].texture = obj_man_texture
				area_to_i[objective] = i
				i += 1


func _on_objective_found(area):
	get_children()[area_to_i.get(area)].modulate.a = 1
