extends Node

enum FinishType {GAME_OVER, WON}

signal finished(type)


func game_over():
	finished.emit(FinishType.GAME_OVER)
	
func won():
	finished.emit(FinishType.WON)
