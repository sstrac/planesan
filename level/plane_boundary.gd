extends StaticBody2D


@export var plane: CharacterBody2D

const SPEED = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not plane.won:
		position.x += delta * SPEED
		global_position.y = lerp(global_position.y, plane.global_position.y, delta )
