extends Node2D


@onready var pages = get_node("Pages").get_children()
@onready var right_button = get_node("TextureButton2")
@onready var left_button = get_node("TextureButton3")
@onready var audio = get_node("AudioStreamPlayer2D")

var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_down() -> void:
	hide()
	audio.play()


func _on_texture_button_2_button_down() -> void:
	pages[i].hide()

	if i < pages.size() - 1:
		i += 1
		audio.play()
		left_button.show()
		right_button.show()
	
	if i == pages.size() - 1:
		right_button.hide()

	pages[i].show()


func _on_texture_button_3_button_down() -> void:
	pages[i].hide()
	if i > 0:
		i -= 1
		audio.play()
		left_button.show()
		right_button.show()
	
	if i == 0:
		left_button.hide()
		
	pages[i].show()
