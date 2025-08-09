extends ColorRect


@export var objective_1: Node2D
@export var objective_2: Node2D
@export var objective_3: Node2D

var objective_1_area: Node2D
var objective_2_area: Node2D
var objective_3_area: Node2D

@onready var area2d = get_node("Area2D")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

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
	audio.play()

func _on_snap_finished(animation):
	area2d.monitoring = false
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.set_collision_layer_value(4, false)
	print('found')
