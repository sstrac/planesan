extends TextureProgressBar


@export var health_comp: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = health_comp.max_health
	value = health_comp.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = health_comp.health
