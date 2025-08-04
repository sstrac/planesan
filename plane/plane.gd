extends CharacterBody2D

const TURBULENCE = 'turbulence'
const EXPLOSION_SCENE = preload("res://plane/explosion.tscn")
const Y_SPEED = 100
const MAX_X_ACCELERATION = 50
const ACCELERATION_FACTOR = 200
const SILENT = -40
const NORMAL_VOLUME = 0

var current_damage = 0

@export var plane_boundary_collision_shape: CollisionPolygon2D

@onready var health_comp: Node = get_node("HealthComponent")
@onready var damage_timer: Timer = get_node("DamageTimer")

@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var audio_anim: AnimationPlayer = get_node("AudioAnimation")

@onready var health_bar: TextureProgressBar = get_node("HealthBar")
@onready var hide_health_bar_timer: Timer = get_node("HideHealthbarTimer")
@onready var planesan: Sprite2D = get_node("Planesan")
@onready var cabin_audio: AudioStreamPlayer2D = get_node("CabinAudio")
@onready var scream_audio: AudioStreamPlayer2D = get_node("ScreamAudio")

var dead: bool = false
var won: bool = false
var grounded_after_death: bool = false
var x_acceleration: float = 0


func _ready():
	health_comp.died.connect(_on_death)
	damage_timer.timeout.connect(_take_damage)
	hide_health_bar_timer.timeout.connect(health_bar.hide)


func _physics_process(delta: float) -> void:
	if not dead and not won:
		var x_direction := Input.get_axis("left", "right")
		if x_direction:
			if abs(x_acceleration) < MAX_X_ACCELERATION:
				x_acceleration += delta * ACCELERATION_FACTOR * x_direction
		else:
			x_acceleration = lerp(x_acceleration, 0.0, delta)

		velocity.x = x_acceleration
		
		if Input.is_action_just_pressed("scroll_up"):
			velocity.y = -Y_SPEED
			
		elif Input.is_action_just_pressed("scroll_down"):
			velocity.y = Y_SPEED
		
		else:
			velocity.y = 0
	
	elif dead:
		velocity.x = 0
		if global_position.y < 375:
			position.y += 1
		elif not grounded_after_death:
			grounded_after_death = true
			await get_tree().create_timer(5).timeout
			add_child(EXPLOSION_SCENE.instantiate())

	elif won:
		velocity.x = x_acceleration
		
	move_and_slide()

func _take_damage():
	health_comp.decrease(current_damage)


func calculate_scream_audio_position():
	return scream_audio.stream.get_length() * (1.0 - health_comp.health / health_comp.max_health)
	

func _on_death():
	dead = true
	planesan.switch_to_broken_texture()
	add_child(EXPLOSION_SCENE.instantiate())
	hide_health_bar_timer.stop()
	health_bar.hide()
	cabin_audio.stop()
	scream_audio.stop()
	for boundary in get_tree().get_nodes_in_group('boundary'):
		boundary.set_deferred('disabled', true)


func _on_area_2d_entered(area: Area2D) -> void:
	if not won:
		if area.collision_layer == 1: #damage dealer
			health_bar.show()
			hide_health_bar_timer.stop()
			
			current_damage += area.damage
			_take_damage()
			damage_timer.start()
			
			anim.play(TURBULENCE)
			scream_audio.play(calculate_scream_audio_position())
			audio_anim.play('louden_screams')
			
			if not scream_audio.playing:
				scream_audio.play(calculate_scream_audio_position())
		
		elif area.collision_layer == 2: #healer
			health_bar.show()
			hide_health_bar_timer.stop()
			health_comp.increase(area.health)
		

func _on_area_2d_exited(area: Area2D) -> void:
	if not won:
		if area.collision_layer == 1: #damage dealer
			current_damage -= area.damage
			damage_timer.stop()
			
			if current_damage <= 0:
				hide_health_bar_timer.start()
			
			anim.stop()
			audio_anim.play_backwards('louden_screams')
			
			await audio_anim.animation_finished
			if audio_anim.current_animation_position == 0:
				scream_audio.stop()
				
		elif area.collision_layer == 2: #healer
			hide_health_bar_timer.start()
			
			
func win_actions():
	plane_boundary_collision_shape.set_deferred('disabled', true)
	won = true
	anim.stop()
	scream_audio.stop()
	health_bar.hide()
