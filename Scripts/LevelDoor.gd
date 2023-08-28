extends Area2D

@export var menu: ColorRect
@export var animation_player: AnimationPlayer
@export var next_level: PackedScene

@export var final_time: Label
@export var final_score: Label
@export var final_rating: Label

func _ready():
	menu.visible = false
	
func _on_body_entered(body):
	if body.name == "Player":
		get_tree().paused = true
		menu.visible = true
		animation_player.play("ui_visibility")
		body.get_node("UI").visible = false
		body.final_score_time_and_rating()
		
		final_time.text = str(Global.final_time)
		final_score.text = str(Global.final_score)
		final_rating.text = str(Global.final_rating)

func _on_restart_button_pressed():
	get_tree().paused = false
	menu.visible = false
	get_tree().reload_current_scene()


func _on_continue_button_pressed():
	get_tree().paused = false
	menu.visible = false
	
	get_tree().change_scene_to_packed(next_level)
	var path = next_level.resource_path
	var scene_name = path.get_file().split(".")[0]
	Global.current_scene_name = scene_name
	print(scene_name)
	
