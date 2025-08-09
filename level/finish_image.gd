extends Sprite2D

const GAME_OVER = preload("res://img/end.png")

func _ready():
	Finish.finished.connect(_on_finish)
	
	
func _on_finish(finish_type):
	match finish_type:
		Finish.FinishType.GAME_OVER: texture = GAME_OVER; show()
