extends AnimatedSprite2D


var follow_plane = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Finish.finished.connect(_on_finish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_plane:
		global_position.y = lerp(global_position.y, LevelTracker.plane.global_position.y - 20, delta)


func _on_finish(finish_type):
	if finish_type == Finish.FinishType.WON:
		follow_plane = false
		if ObjectiveTracker.all_found:
			get_children().map(func(p): if p.is_class('CPUParticles2D'): p.emitting = true)
			get_node("AudioStreamPlayer2D").play()
