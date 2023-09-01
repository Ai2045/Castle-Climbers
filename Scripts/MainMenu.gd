extends CanvasLayer

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_new_pressed():
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load("res://Scenes/Main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	Global.current_scene_name = new_scene.name
	if Global.get_current_level_number() > 1:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_load_pressed():
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	Global.load_game()
	if Global.get_current_level_number() > 1:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_quit_pressed():
	get_tree().quit()
