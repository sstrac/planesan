extends Node2D


@onready var sprite = get_node("AnimatedSprite2D")
func pop():
	sprite.hide()
	get_node("PopParticles").emitting = true

func _process(delta):
	if not sprite.visible:
		await get_tree().create_timer(1).timeout
		queue_free()
