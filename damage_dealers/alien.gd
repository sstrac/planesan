extends Node2D


const PINK = preload("res://damage_dealers/alien_pink.png")

@export var activation_min_pos: Vector2
@export var activation_max_pos: Vector2
@export var is_objective: bool

@onready var area2d = get_node("Sprite2D/Area2D")
@onready var sprite = get_node("Sprite2D")
@onready var objective_manager = get_node("Sprite2D/ObjectiveManager")
@onready var default_audio: AudioStreamPlayer2D = get_node("DefaultAlienAudio")
@onready var annoyed_audio = get_node("AnnoyedAlienAudio")
@onready var return_timer: Timer = get_node("ReturnTimer")

var hide = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SnapperTracker.snapped.connect(_on_snapped)
	return_timer.timeout.connect(_unhide)
	if is_objective:
		objective_manager.set_objective()

func _unhide(): 
	hide = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var plane_pos = LevelTracker.plane.global_position
	
	if hide:
		var direction_away = plane_pos.direction_to(sprite.global_position)
		global_position = lerp(global_position, global_position + Vector2.ONE * 32 * direction_away, delta * 2)
	else:
		
		var within_min_y = plane_pos.y > activation_min_pos.y
		var within_max_y = plane_pos.y < activation_max_pos.y
		var within_min_x = plane_pos.x > activation_min_pos.x
		var within_max_x = plane_pos.x < activation_max_pos.x
		if within_min_y and within_max_y and within_min_x and within_max_x:
			var dir_to_alien = sign(global_position.direction_to(sprite.global_position))
			var new_center_pos = lerp(global_position, plane_pos, delta)
			if sign(new_center_pos.x) != dir_to_alien.x:
				global_position = Vector2(global_position.x, new_center_pos.y)
			if sign(new_center_pos.y) != dir_to_alien.y:
				global_position = Vector2(new_center_pos.x, global_position.y)
			else:
				global_position = Vector2(new_center_pos.x + delta * 10, new_center_pos.y)


func _on_balloon_detection_area_area_entered(area: Area2D) -> void:
	_alien_happy()


func _alien_happy():
	get_node("Sprite2D/Heart").emitting = true
	get_node("Sprite2D/AudioStreamPlayer2D").play()
	sprite.texture = PINK
	objective_manager.activate_objective_collision_layer()


func _on_snapped(area):
	if area == area2d:
		hide = true
		return_timer.stop()
		return_timer.start()
		default_audio.stream_paused = true
		annoyed_audio.play()
		await get_tree().create_timer(1.5).timeout
		default_audio.stream_paused = false
