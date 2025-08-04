extends StaticBody2D


@export var plane: CharacterBody2D

const SPEED = 5

var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not plane.won:
		if not plane.game_over:
			position.x += delta * speed
			global_position.y = lerp(global_position.y, plane.global_position.y, delta)
			
		else:
			global_position = lerp(global_position, plane.global_position, delta * 10)
