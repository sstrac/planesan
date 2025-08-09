extends CharacterBody2D

@export var plane_boundary: Camera2D

const TURBULENCE = 'turbulence'
const EXPLOSION_SCENE = preload("res://plane/explosion.tscn")
const SILENT = -40
const NORMAL_VOLUME = 0

const MAX_X_VELOCITY = 50
const MAX_Y_POS = -50
const REDUCTION_FACTOR_START_Y_POS = 0
const GROUND_Y_POS = 375
const BOUNDARY_DISTANCE_FROM_CENTER = 32
const MAX_SCROLL_STRENGTH = 30

@onready var health_comp: Node = get_node("HealthComponent")
@onready var damage_timer: Timer = get_node("DamageTimer")

@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var audio_anim: AnimationPlayer = get_node("AudioAnimation")

@onready var health_bar: TextureProgressBar = get_node("HealthBar")
@onready var hide_health_bar_timer: Timer = get_node("HideHealthbarTimer")
@onready var planesan: Sprite2D = get_node("Planesan")
@onready var cabin_audio: AudioStreamPlayer2D = get_node("CabinAudio")
@onready var scream_audio: AudioStreamPlayer2D = get_node("ScreamAudio")

@onready var area2d: Area2D = get_node("Area2D")

var game_over: bool = false
var won: bool = false
var crashed_on_ground = false

var scroll_strength: float = 0
var movement_weight: float = 1

var exposure_damage = 0

func _ready():
	Finish.finished.connect(_on_finish)
	health_comp.died.connect(_on_death)
	damage_timer.timeout.connect(_take_damage)
	hide_health_bar_timer.timeout.connect(health_bar.hide)


func _physics_process(delta: float) -> void:
	if game_over:
		velocity.x = 0
		if position.y < GROUND_Y_POS:
			velocity.y = 50
		else:
			velocity.y = 0
			_hit_ground()

	elif won:
		position.x += 1
	
	else:
		_x_movement(delta)
		_y_movement(delta)
		
		if movement_weight < 0.05:
			Finish.game_over()
		
	move_and_slide()


func _x_movement(delta):
	var camera = get_viewport().get_camera_2d()
	var left_bound_pos = camera.global_position.x - BOUNDARY_DISTANCE_FROM_CENTER
	var right_bound_pos = camera.global_position.x + BOUNDARY_DISTANCE_FROM_CENTER
	
	var breaches_left_boundary = global_position.x < left_bound_pos
	var breaches_right_boundary = global_position.x > right_bound_pos
	
	if breaches_left_boundary:
		position.x = left_bound_pos + 1
		velocity.x = 0
	elif breaches_right_boundary:
		position.x = right_bound_pos - 1
		velocity.x = 0
	
	if Input.is_action_pressed("left_click"):
		if abs(velocity.x) < MAX_X_VELOCITY:
			velocity.x -= 1
	elif Input.is_action_pressed("right_click"):
		if abs(velocity.x) < MAX_X_VELOCITY:
			velocity.x += 1
	
	velocity.x = lerp(velocity.x, 0.0, delta * 1)


func _y_movement(delta):
	if Input.is_action_just_pressed("scroll_up"):
		if sign(scroll_strength) == 1:
			scroll_strength = 0
		if abs(scroll_strength) < MAX_SCROLL_STRENGTH:
			scroll_strength -= 3
	elif Input.is_action_just_pressed("scroll_down"):
		if sign(scroll_strength) == -1:
			scroll_strength = 0
		if abs(scroll_strength) < MAX_SCROLL_STRENGTH:
			scroll_strength += 3

	
	if abs(scroll_strength) < 1:
		scroll_strength = 0
	elif scroll_strength != 0:
		scroll_strength = lerp(scroll_strength, 0.0, delta)
		
	#Space logic
	var distance_to_max_y = abs(MAX_Y_POS - global_position.y)
	
	if distance_to_max_y > abs((MAX_Y_POS - REDUCTION_FACTOR_START_Y_POS)):
		movement_weight = 1
	else:
		movement_weight = distance_to_max_y / abs(MAX_Y_POS - REDUCTION_FACTOR_START_Y_POS)
	
	velocity.y = scroll_strength * movement_weight


func _hit_ground():
	if not crashed_on_ground:
		add_child(EXPLOSION_SCENE.instantiate())
		scream_audio.stop()
		audio_anim.stop()
		crashed_on_ground = true
	
	
func _take_damage():
	health_comp.decrease(exposure_damage)


func calculate_scream_audio_position():
	return scream_audio.stream.get_length() * (1.0 - float(health_comp.health) / health_comp.max_health)
	

func _on_death():
	Finish.game_over()
	

func _on_finish(finish_type):
	match finish_type:
		Finish.FinishType.GAME_OVER:
			game_over = true
			health_comp.died.disconnect(_on_death)
			planesan.switch_to_broken_texture()
			add_child(EXPLOSION_SCENE.instantiate())
			hide_health_bar_timer.stop()
			health_bar.hide()
			cabin_audio.stop()

			for boundary in get_tree().get_nodes_in_group('boundary'):
				boundary.set_deferred('disabled', true)
				
		Finish.FinishType.WON:
			pass

	
func _on_area_2d_entered(area: Area2D) -> void:
	if not won:
		if area.get_collision_layer_value(1): #damage dealer
			if game_over:
				anim.play(TURBULENCE)
			else:
				health_bar.show()
				hide_health_bar_timer.stop()
				
				health_comp.decrease(area.damage)
				exposure_damage += area.damage
				
				damage_timer.start()
				
				anim.play(TURBULENCE)
				scream_audio.play(calculate_scream_audio_position())
				audio_anim.play('louden_screams')
				
				if not scream_audio.playing:
					scream_audio.play(calculate_scream_audio_position())
		
		elif area.get_collision_layer_value(2): #healer
			health_bar.show()
			hide_health_bar_timer.stop()
			health_comp.increase(area.health)
		

func _on_area_2d_exited(area: Area2D) -> void:
	if not won:
		if area.get_collision_layer_value(1): #damage dealer
			if game_over:
				anim.stop()
			else:
				exposure_damage -= area.damage
				damage_timer.stop()
				
				if exposure_damage <= 0:
					hide_health_bar_timer.start()
				
				anim.stop()
				audio_anim.play_backwards('louden_screams')
				
				await audio_anim.animation_finished
				if audio_anim.current_animation_position == 0:
					scream_audio.stop()
				
		elif area.get_collision_layer_value(2): #healer
			hide_health_bar_timer.start()
			
			
func win_actions():
	won = true
	anim.stop()
	scream_audio.stop()
	health_bar.hide()
