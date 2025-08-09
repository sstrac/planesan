extends Node

@export var texture: Texture
@export var area: Area2D


func activate_objective_collision_layer():
	area.set_collision_layer_value(4, true)
	area.add_to_group('objective')
