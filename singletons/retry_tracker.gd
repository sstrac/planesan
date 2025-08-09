extends Node


func clear_groups():
	for node in get_tree().get_nodes_in_group('objective'):
		node.remove_from_group('objective')
