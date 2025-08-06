extends StaticBody2D

const BOUNDARY_LERP_SPEED = 12
const MIN_DISTANCE_TO_PLANE_TO_FOLLOW = 6

@export var plane: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not plane.won:
		if not plane.game_over:
			position.x += delta * Speed.X_PAN_SPEED
			global_position.y = lerp(global_position.y, plane.global_position.y, delta)
			
		else:
			if global_position.distance_to(plane.global_position) > MIN_DISTANCE_TO_PLANE_TO_FOLLOW:
				global_position = lerp(global_position, plane.global_position, delta * BOUNDARY_LERP_SPEED)
			else:
				global_position = round(plane.global_position)
