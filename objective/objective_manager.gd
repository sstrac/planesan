extends Node

var texture: Texture


func set_objective(area: Area2D, _texture: Texture):
	area.set_collision_layer_value(4, true)
	area.add_to_group('objective')
	texture = _texture
