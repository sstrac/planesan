extends Node2D


@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

var popped = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_health_dealer_area_entered(area: Area2D) -> void:
	if not popped:
		popped = true
		for balloon in get_node("Balloons").get_children():
			balloon.pop()
		
		audio.play()
		await audio.finished
		queue_free()
