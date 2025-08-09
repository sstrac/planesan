extends Node


signal found


func mark_found(area):
	found.emit(area)
