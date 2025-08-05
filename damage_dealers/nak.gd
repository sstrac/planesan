extends AnimatedSprite2D


@export var plane_boundary: StaticBody2D

var rolling_delta: float
var x_deviation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rolling_delta += delta
	x_deviation = cos(rolling_delta * 2)
	global_position.x = plane_boundary.global_position.x + x_deviation * 15
