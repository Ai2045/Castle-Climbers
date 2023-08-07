extends CharacterBody2D

@export var speed = 100
@export var gravity = 200
@export var jump_height = -100
@export var player_sprite: AnimatedSprite2D
@export var player_collisionShape: CollisionShape2D

var is_attacking = false
var is_climbing = false

func _physics_process(delta):
	
	velocity.y += gravity * delta
	horizontal_movement()
	move_and_slide()
	player_animations()
	
func horizontal_movement():
	
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed

func player_animations():
	
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		player_sprite.flip_h = true
		player_sprite.play("run")
		player_collisionShape.position.x = 7
		
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		player_sprite.flip_h = false
		player_sprite.play("run")
		player_collisionShape.position.x = -7
		
	if !Input.is_anything_pressed():
		player_sprite.play("idle")

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		player_sprite.play("attack")
		
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		player_sprite.play("jump")
		
	if is_climbing == true:
		if Input.is_action_pressed("ui_up"):
			player_sprite.play("climb")
			gravity = 100
			velocity.y = -200
		else :
			gravity = 200
			is_climbing = false

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
