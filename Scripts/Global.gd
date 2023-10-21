extends Node

var is_attacking = false
var is_climbing = false
var is_jumping = false

var can_spawn = true

var current_scene_name

var is_bomb_moving = false

func _ready():
	var scene_name = get_tree().get_current_scene().name
	current_scene_name = clean_scene_name(scene_name)

func disable_spawning():
	can_spawn = false
	
func enable_spawning():
	can_spawn = true
	
enum Pickups {HEALTH, SCORE, ATTACK}

var can_hurt = true

var final_score
var final_rating
var final_time


const  SAVE_PATH = "user://savegame.save"

func save_game():
	var save_file = ConfigFile.new()
	
	save_file.set_value("level", "current_level", "res://Scenes/" + Global.current_scene_name + ".tscn")
	var err = save_file.save(SAVE_PATH)
	
	if err != OK:
		print("An error occurred while saving  the game")
	else:
		print("Saving game.")
		
func load_game():
	var save_file = ConfigFile.new()
	var err = save_file.load(SAVE_PATH)
	
	if err == OK:
		print("Loading game.")
		var saved_level = save_file.get_value("level", "current_level", "res://Scenes/Main.tscn")
		var new_scene_resource = load(saved_level)
		var new_scene = new_scene_resource.instantiate()
		get_tree().get_root().add_child(new_scene)
		get_tree().current_scene = new_scene
		clean_scene_name(current_scene_name)
	else :
		print("An error occurred while loading the game")

func clean_scene_name(scene_name):
	var at_position = scene_name.find("@")
	if at_position != -1:
		return scene_name.substr(0, at_position)
	else:
		return scene_name
		
func get_current_level_number():
	if current_scene_name == "Main" || current_scene_name == "MainMenu" || current_scene_name == "select_menu":
		return 1
	elif current_scene_name.begins_with("Main_"):
		var level_number = current_scene_name.get_slice("_", 1).to_int()
		return level_number
	else :
		return -1

var current_difficolt = 0
