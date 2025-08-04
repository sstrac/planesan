extends "res://damage_dealers/clouds/cloud.gd"

const LIGHTNING_TIME = 8.11

@onready var cloud = get_node("AnimatedSprite2D")
@onready var lightning = get_node("ThundercloudLightning")
@onready var timer = get_node("Timer")
@onready var audio = get_node("AudioStreamPlayer2D")
@onready var lightning_polygon = get_node("DamageDealer2/LightningPolygon")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_lightning_bolt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _lightning_bolt():
	lightning.show()
	cloud.hide()
	lightning_polygon.set_deferred('disabled', false)
	await get_tree().create_timer(0.1).timeout
	lightning.hide()
	cloud.show()
	timer.wait_time = randf() * 10
	audio.play(LIGHTNING_TIME)
	lightning_polygon.set_deferred('disabled', true)
	
	
