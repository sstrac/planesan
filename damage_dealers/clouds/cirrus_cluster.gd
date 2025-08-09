extends Node2D

const SPEED = 2
const TRIGGER_X_DISTANCE = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if abs(PlaneTracker.plane.global_position.x - global_position.x) < TRIGGER_X_DISTANCE:
		position.x -= SPEED
