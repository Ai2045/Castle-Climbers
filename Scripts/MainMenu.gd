extends CanvasLayer


func _on_button_new_pressed():
	var current_scene = get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load("res://Scenes/Main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	Global.current_scene_name = new_scene.name
	get_tree().paused = false

func _on_button_load_pressed():
	pass # Replace with function body.


func _on_button_quit_pressed():
	get_tree().quit()
