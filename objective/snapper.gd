extends ColorRect


@export var objective_1: Node2D
@export var objective_2: Node2D
@export var objective_3: Node2D

var objective_1_area: Node2D
var objective_2_area: Node2D
var objective_3_area: Node2D

@onready var area2d = get_node("Area2D")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var shutter: AudioStreamPlayer2D = get_node("Shutter")
@onready var jingle: AudioStreamPlayer2D = get_node("ObjectiveFound")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.animation_finished.connect(_on_snap_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_click"):
		area2d.monitoring = true
		play()


func play():
	anim.stop()
	anim.play('snap')
	shutter.play()


func _on_snap_finished(animation):
	area2d.monitoring = false
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(4):
		area.set_collision_layer_value(4, false)
		jingle.play()

		ObjectiveTracker.mark_found(area)
	elif area.get_collision_layer_value(7):
		SnapperTracker.snapped.emit(area)
