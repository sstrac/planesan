extends Camera2D

const BOUNDARY_LERP_SPEED = 12
const MIN_DISTANCE_TO_PLANE_TO_FOLLOW = 6

@export var finish_flag: AnimatedSprite2D

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not LevelTracker.plane.won:
		if not LevelTracker.plane.game_over:
			position.x += delta * Speed.X_PAN_SPEED
			
			global_position.y = lerp(global_position.y, LevelTracker.plane.global_position.y, delta)
			
		else:
			if global_position.distance_to(LevelTracker.plane.global_position) > MIN_DISTANCE_TO_PLANE_TO_FOLLOW:
				global_position = lerp(global_position, LevelTracker.plane.global_position, delta * BOUNDARY_LERP_SPEED)
			else:
				global_position = round(LevelTracker.plane.global_position)
	else:
		global_position = lerp(global_position, finish_flag.global_position + Vector2(0, 10), delta)
