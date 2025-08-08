extends Node2D


@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
@onready var health_dealer: Area2D = get_node("HealthDealer")


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_health_dealer_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(16):
		health_dealer.set_deferred('monitoring', false)
		for balloon in get_node("Balloons").get_children():
			balloon.pop()
		
		audio.play()
		await audio.finished
		queue_free()
