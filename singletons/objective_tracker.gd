extends Node


signal found

var all_found: bool = false

func mark_found(area):
	found.emit(area)
