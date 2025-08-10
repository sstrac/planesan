@tool
extends Sprite2D

const R = 20
var rolling_delta = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rolling_delta += delta
	#var plane_pos = PlaneTracker.plane.global_position
	position = Vector2(R * cos(rolling_delta), R * sin(rolling_delta))
