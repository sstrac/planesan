extends Node

const UPTONE = preload("res://audio/uptone.wav")

@export var heart: CPUParticles2D
@export var sfx: AudioStreamPlayer2D

var max_health: int = 20
var health: int

signal died

func _ready():
	health = max_health

func decrease(amt):
	health -= amt
	
	if health <= 0:
		died.emit()
		
func increase(amt):
	sfx.stream = UPTONE
	sfx.play()
	heart.emitting = true
	health += amt
	
	if health > max_health:
		health = max_health
