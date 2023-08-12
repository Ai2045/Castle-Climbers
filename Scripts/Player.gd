extends CharacterBody2D

@export var speed = 100
@export var gravity = 200
@export var jump_height = -100
@export var player_sprite: AnimatedSprite2D
@export var player_collisionShape: CollisionShape2D


func _physics_process(delta):
	
	velocity.y += gravity * delta
	horizontal_movement()
	move_and_slide()
	
	if !Global.is_attacking || Global.is_climbing:
		player_animations()
	
func horizontal_movement():
	
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed

func player_animations():
	
	if Input.is_action_pressed("ui_left") && Global.is_jumping == false:
		player_sprite.flip_h = true
		player_sprite.play("run")
		player_collisionShape.position.x = 7
		
	if Input.is_action_pressed("ui_right") && Global.is_jumping == false:
		player_sprite.flip_h = false
		player_sprite.play("run")
		player_collisionShape.position.x = -7
		
	if !Input.is_anything_pressed():
		player_sprite.play("idle")

func _input(event):
	if event.is_action_pressed("ui_attack"):
		Global.is_attacking = true
		player_sprite.play("attack")
		
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		player_sprite.play("jump")
		
	if Global.is_climbing == true:
		if !Input.is_anything_pressed():
			player_sprite.play("idle")
			
		if Input.is_action_pressed("ui_up"):
			player_sprite.play("climb")
			gravity = 100
			velocity.y = -160
			Global.is_jumping = false
			
	else:
			gravity = 200
			Global.is_climbing = false  
			Global.is_jumping = false

func _on_animated_sprite_2d_animation_finished():
	Global.is_attacking = false
	Global.is_climbing = false
