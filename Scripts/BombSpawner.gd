extends Node2D

var bomb = preload("res://Scenes/Bomb.tscn")

var current_scene_path
var bomb_path
var bomb_animation

@export var animated_sprite: AnimatedSprite2D
func _ready():
	animated_sprite.play("cannon_idle")
	
	update_paths()
	if bomb_animation != null:
		bomb_animation.play("bomb_movement")
	else:
		print("bomb_animation is null")

func update_paths():
	current_scene_path = "/root/" + Global.current_scene_name + "/"
	bomb_path =  get_node(current_scene_path + "/BombPath/Path2D/PathFollow2D")
	bomb_animation = get_node(current_scene_path + "/BombPath/Path2D/AnimationPlayer")
	
func shoot():
	animated_sprite.play("cannon_fired")
	Global.is_bomb_moving = true
	bomb_animation.play("bomb_movement")
	var spawned_bomb = bomb.instantiate()
	return spawned_bomb

func _on_timer_timeout():
	animated_sprite.play("cannon_idle")
	
	if bomb_path == null || bomb_animation == null:
		update_paths()
		
	if bomb_path != null and bomb_path.get_child_count() == 0:
		bomb_path.add_child(shoot())
	
	if bomb_path != null:
		if Global.is_bomb_moving == false:
			for bombs in bomb_path.get_children():
				bomb_path.remove_child(bombs)
				bombs.queue_free()
				bomb_animation.stop()
