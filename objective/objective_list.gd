extends Control

const ANIM_OBJ_SCENE = preload("res://objective/animated_objective.tscn")

@onready var anim = get_node("AnimationPlayer")
@onready var objectives = get_node("HBoxContainer/CenterObjectives/Objectives").get_children()
@onready var book = get_node("CenterContainer/Book")
@onready var open_book = get_node("OpenBook")
@onready var open_book_audio = get_node("CenterContainer/AudioStreamPlayer2D")
@onready var cash_in_audio = get_node("CashInAudio")
@onready var book_sparkles = get_node("CenterContainer/BookSparkles")
@onready var level_sparkles = get_node("Levels/Level2Button/LevelSparkles")
@onready var level_1_button = get_node("Levels/Level1Button")
@onready var level_2_button = get_node("Levels/Level2Button")
@onready var audio = get_node("AudioStreamPlayer2D")

var i = 0
var area_to_i = {}

#TEST remember to disable the level 2 button when finished QAing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Finish.finished.connect(_on_finish)
	ObjectiveTracker.found.connect(_on_objective_found)
	_set_objectives()
	
	if LevelTracker.current_level == 1 and LevelTracker.level_1_complete:
		level_2_button.disabled = false
		level_2_button.modulate.a = 1
	elif LevelTracker.current_level == 2:
		level_1_button.disabled = false
		level_1_button.modulate.a = 1
		

func _set_objectives():
	for objective: Area2D in get_tree().get_nodes_in_group('objective'):
		var parent = objective.get_parent()
		if parent.has_node("ObjectiveManager"):
			var obj_man_texture = parent.get_node("ObjectiveManager").texture
			var existing_textures = objectives.map(func(n): return n.texture)
			if existing_textures.has(obj_man_texture):
				area_to_i[objective] = existing_textures.find(obj_man_texture)
			else:
				objectives[i].texture = obj_man_texture
				area_to_i[objective] = i
				i += 1


func _on_objective_found(area):
	var objective = objectives[area_to_i.get(area)]
	objective.modulate.a = 1
	objective.obtained = true
	

func _on_finish(finish_type):
	if finish_type == Finish.FinishType.WON:
		ObjectiveTracker.all_found = objectives.all(func(t): return t.obtained)
		if ObjectiveTracker.all_found:
			book.disabled = false
			book.modulate.a = 1
			anim.play('center_book')
			await anim.animation_finished
			
			for objective in objectives:
				if objective.obtained:
					var sprite = ANIM_OBJ_SCENE.instantiate()
					sprite.texture = objective.texture
					sprite.book = book
					objective.add_child(sprite)
					await sprite.tree_exited
					cash_in_audio.play()
					book_sparkles.emitting = true
					
			await get_tree().create_timer(1).timeout
			level_2_button.disabled = false
			level_2_button.modulate.a = 1
			cash_in_audio.play()
			level_sparkles.emitting = true
			
			if LevelTracker.current_level == 1:
				LevelTracker.level_1_complete = true


func _on_level_1_button_pressed() -> void:
	if LevelTracker.current_level != 1:
		LevelTracker.change_level_to(1)


func _on_level_2_button_pressed() -> void:
	if LevelTracker.current_level != 2:
		LevelTracker.change_level_to(2)


func _on_book_pressed() -> void:
	open_book_audio.play()
	open_book.show()


func _on_level_2_button_button_down() -> void:
	KeySounds.key_down()

func _on_level_1_button_button_down() -> void:
	KeySounds.key_down()


func _on_level_1_button_button_up() -> void:
	KeySounds.key_up()
	
func _on_level_2_button_button_up() -> void:
	KeySounds.key_up()
