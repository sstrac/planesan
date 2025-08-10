extends Sprite2D

const MAX_DISTANCE_FROM_PLANE = 20

var follow = false

func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(_follow)

func _process(delta: float) -> void:
	if follow:
		var plane_pos = PlaneTracker.plane.global_position
		
		if global_position.distance_to(plane_pos) > MAX_DISTANCE_FROM_PLANE:
			global_position += global_position.direction_to(plane_pos).normalized()
	else:
		global_position.y = lerp(global_position.y, global_position.y - 20, delta)

func _follow():
	follow = true
