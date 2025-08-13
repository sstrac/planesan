extends Node2D


@onready var pages = get_node("Pages").get_children()
@onready var right_button = get_node("TextureButton2")
@onready var left_button = get_node("TextureButton3")
@onready var audio = get_node("AudioStreamPlayer2D")

var i = 0
var complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ObjectiveTracker.all_found and not complete:
		_reveal_page()
		complete = true


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

	if i == 6 and complete:
		get_node("AlienNoises").play()
	else:
		get_node("AlienNoises").stop()
		
	pages[i].show()


func _on_texture_button_3_button_down() -> void:
	get_node("AlienNoises").stop()
	pages[i].hide()
	if i > 0:
		i -= 1
		audio.play()
		left_button.show()
		right_button.show()
	
	if i == 0:
		left_button.hide()
		
	pages[i].show()


func _reveal_page():
	get_node("Pages/ColorRect").modulate = Color.WHITE
