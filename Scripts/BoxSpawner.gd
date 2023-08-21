extends Node2D

var box = preload("res://Scenes/Box.tscn")

@export var box_path: PathFollow2D
@export var box_animation: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D

@export var flip_h = false
@export var flip_v = false

func _ready():
	box_animation.play("box_movement")
	animated_sprite.play("pig_throw")

func _on_timer_timeout():
	animated_sprite.play("pig_idle")
	
	if box_path.get_child_count() <= 0 and Global.can_spawn == true:
		var spawned_box = box.instantiate()
		box_path.add_child(spawned_box)

func _process(delta):
	animated_sprite.flip_h = flip_h
	animated_sprite.flip_v = flip_v
	
	if box_path.progress_ratio >=1:
		box_path.progress_ratio = 0
		Global.enable_spawning()
		box_animation.play("box_movement")
	
	if box_path.progress_ratio == 0:
		animated_sprite.play("pig_throw")
