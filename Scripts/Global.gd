extends Node

var is_attacking = false
var is_climbing = false
var is_jumping = false

var current_scene_name

var is_bomb_moving = false

func _ready():
	current_scene_name = get_tree().get_current_scene().name
