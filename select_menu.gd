extends CanvasLayer

@export var background_music: AudioStreamPlayer

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	background_music.play()


func _on_simple_pressed():
	Global.current_difficolt = 1
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load("res://Scenes/Main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	Global.current_scene_name = new_scene.name
	

func _on_difficolt_pressed():
	Global.current_difficolt = 2
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load("res://Scenes/Main_2.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	Global.current_scene_name = new_scene.name
	

func _on_return_pressed():
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load("res://Scenes/main_menu.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	Global.current_scene_name = new_scene.name
