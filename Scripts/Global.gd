extends Node

var is_attacking = false
var is_climbing = false
var is_jumping = false

var can_spawn = true

var current_scene_name

var is_bomb_moving = false

func _ready():
	current_scene_name = get_tree().get_current_scene().name

func disable_spawning():
	can_spawn = false
	
func enable_spawning():
	can_spawn = true
	
enum Pickups {HEALTH, SCORE, ATTACK}

var can_hurt = true

var final_score
var final_rating
var final_time

func get_current_level_number():
	if current_scene_name == "Main":
		return 1
	elif  current_scene_name.begins_with("Main_"):
		var level_number = current_scene_name.get_slice("_", 1).to_int()
		return level_number
	else :
		return -1
