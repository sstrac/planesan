extends Node


@export var max_health: float
var health: float

signal died

func _ready():
	health = max_health

func decrease(amt):
	health -= amt
	
	if health <= 0:
		died.emit()
		
func increase(amt):
	health += amt
	
	if health > max_health:
		health = max_health
