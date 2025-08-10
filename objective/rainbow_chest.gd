extends AnimatedSprite2D

const FOLLOW_BALLOON = preload("res://objective/follow_balloon.tscn")

@onready var audio = get_node("AudioStreamPlayer2D")

var follow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.finished.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_node("Area2D").set_deferred('monitoring', false)
	audio.play()
	get_node("PopParticles").emitting = true
	var follow_balloon = FOLLOW_BALLOON.instantiate()
	call_deferred('add_sibling', follow_balloon)
	hide()
