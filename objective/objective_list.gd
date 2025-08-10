extends Control

const ANIM_OBJ_SCENE = preload("res://objective/animated_objective.tscn")

var i = 0
var area_to_i = {}

@onready var anim = get_node("AnimationPlayer")
@onready var container = get_node("HBoxContainer")
@onready var book = get_node("Book")
@onready var open_book = get_node("OpenBook")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Finish.finished.connect(_on_finish)
	ObjectiveTracker.found.connect(_on_objective_found)
	_set_objectives()


func _set_objectives():
	for objective: Area2D in get_tree().get_nodes_in_group('objective'):
		var parent = objective.get_parent()
		if parent.has_node("ObjectiveManager"):
			var obj_man_texture = parent.get_node("ObjectiveManager").texture
			if not container.get_children().map(func(n): return n.texture).has(obj_man_texture):
				container.get_children()[i].texture = obj_man_texture
				area_to_i[objective] = i
				i += 1


func _on_objective_found(area):
	get_children()[area_to_i.get(area)].modulate.a = 1
	

#TODO Create a new scene which has an animation player for a sprite to drag to the centre of the screen
func _on_finish(finish_type):
	book.show()
	
	anim.play('center_book')
	await anim.animation_finished
	
	for texture_rect in container.get_children():
		if texture_rect.modulate.a == 1:
			var sprite = ANIM_OBJ_SCENE.instantiate()
			sprite.texture = texture_rect.texture
			sprite.book = book
			texture_rect.add_child(sprite)
			await sprite.tree_exited
	
	


func _on_book_button_down() -> void:
	open_book.show()
