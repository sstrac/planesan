extends "res://damage_dealers/clouds/cloud.gd"

const LIGHTNING_TIME = 8.11
const ACTIVATION_X_DISTANCE_TO_PLANE = 50
const PLANE_IN_RANGE_Y = 32
const PLANE_IN_RANGE_X = 10
const BOLT_CHANCE_WHEN_IN_RANGE = 3

@export var is_objective: bool

@onready var cloud = get_node("AnimatedSprite2D")
@onready var lightning = get_node("ThundercloudLightning")
@onready var timer: Timer = get_node("Timer")
@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
@onready var lightning_polygon = get_node("DamageDealer2/LightningPolygon")
@onready var objective_manager = get_node("ObjectiveManager")

var plane_position
var intial_bolt_triggered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_objective:
		objective_manager.set_objective()
		objective_manager.activate_objective_collision_layer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	plane_position = PlaneTracker.plane.global_position
	if abs(global_position.distance_to(plane_position)) < ACTIVATION_X_DISTANCE_TO_PLANE:
		if not timer.timeout.is_connected(_lightning_bolt):
			timer.timeout.connect(_lightning_bolt)
	
	position.x -= randf() * delta * x_speed

	var y_diff = plane_position.y - global_position.y
	var x_diff = abs(plane_position.x - global_position.x)

	if not intial_bolt_triggered:
		if plane_position.y - global_position.y < PLANE_IN_RANGE_Y and y_diff > 0 and x_diff < PLANE_IN_RANGE_X:
			if range(1,10).pick_random() <= BOLT_CHANCE_WHEN_IN_RANGE:
				_lightning_bolt()
				intial_bolt_triggered = true
			

func _lightning_bolt():
	lightning.show()
	cloud.hide()
	lightning_polygon.set_deferred('disabled', false)
	await get_tree().create_timer(0.1).timeout
	lightning.hide()
	cloud.show()
	timer.wait_time = randf() * 6
	audio.play(LIGHTNING_TIME)
	lightning_polygon.set_deferred('disabled', true)
