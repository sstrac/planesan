extends CharacterBody2D

const TURBULENCE = 'turbulence'
const EXPLOSION_SCENE = preload("res://plane/explosion.tscn")
const Y_SPEED = 2
const MAX_X_ACCELERATION = 50
const ACCELERATION_FACTOR = 200

var current_damage = 0

@onready var health_comp: Node = get_node("HealthComponent")
@onready var damage_timer: Timer = get_node("DamageTimer")

@onready var anim: AnimationPlayer = get_node("AnimationPlayer")

@onready var health_bar: TextureProgressBar = get_node("HealthBar")
@onready var hide_health_bar_timer: Timer = get_node("HideHealthbarTimer")
@onready var planesan: Sprite2D = get_node("Planesan")
@onready var cabin_audio: AudioStreamPlayer2D = get_node("CabinAudio")
@onready var scream_audio: AudioStreamPlayer2D = get_node("ScreamAudio")

var dead: bool = false
var grounded_after_death: bool = false
var x_acceleration: float = 0


func _ready():
	health_comp.died.connect(_on_death)
	damage_timer.timeout.connect(_take_damage)
	hide_health_bar_timer.timeout.connect(health_bar.hide)


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not dead:
		var x_direction := Input.get_axis("left", "right")
		if x_direction:
			if abs(x_acceleration) < MAX_X_ACCELERATION:
				x_acceleration += delta * ACCELERATION_FACTOR * x_direction
		else:
			x_acceleration = lerp(x_acceleration, 0.0, delta)

		velocity.x = x_acceleration
		
		if Input.is_action_just_pressed("scroll_up"):
			position.y -= Y_SPEED
			
		if Input.is_action_just_pressed("scroll_down"):
			position.y += Y_SPEED
		
		move_and_slide()
	
	else:
		if global_position.y < 375:
			position.y += 1
		elif not grounded_after_death:
			grounded_after_death = true
			await get_tree().create_timer(5).timeout
			add_child(EXPLOSION_SCENE.instantiate())


func _take_damage():
	health_comp.decrease(current_damage)
	
	if not scream_audio.playing:
		scream_audio.play()
	

func _on_death():
	dead = true
	planesan.switch_to_broken_texture()
	add_child(EXPLOSION_SCENE.instantiate())
	hide_health_bar_timer.stop()
	health_bar.hide()
	cabin_audio.stop()


func _on_damage_area_area_entered(area: Area2D) -> void:
	health_bar.show()
	hide_health_bar_timer.stop()
	
	current_damage += area.damage
	_take_damage()
	scream_audio.play()
	damage_timer.start()
	
	anim.play(TURBULENCE)


func _on_damage_area_area_exited(area: Area2D) -> void:
	current_damage -= area.damage
	damage_timer.stop()
	
	anim.stop()
	
	if current_damage <= 0:
		hide_health_bar_timer.start()
	
