extends Node


signal found

var all_found: bool

func mark_found(area):
	found.emit(area)
