extends CharacterBody2D

signal update_lives(lives, max_lives)

@export var max_lives = 3
@export var lives = 3
@export var speed = 100
@export var gravity = 200
@export var jump_height = -150

var last_direction = 0
var current_direction = 0

@export var player_sprite: AnimatedSprite2D
@export var player_collisionShape: CollisionShape2D
@export var animation_player: AnimationPlayer
@export var offset_camera: Camera2D
@export var health: ColorRect
@export var health_label: Label

func _ready():
	current_direction = -1
	
	update_lives.connect(health.update_lives)
	health_label.text = str(lives)
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
	set_physics_process(true)

func _process(delta):
	if velocity.x > 0:
		current_direction = 1
	elif velocity.x < 0:
		current_direction = -1
	
	if current_direction != last_direction:
		if current_direction == 1:
			animation_player.play("move_right")
			
			offset_camera.limit_left = -110
			offset_camera.limit_bottom = 705
			offset_camera.limit_top = 40
			offset_camera.limit_right = 1068
			
		elif current_direction == -1:
			animation_player.play("move_left")
			
			offset_camera.limit_left = 90
			offset_camera.limit_bottom = 705
			offset_camera.limit_top = 40
			offset_camera.limit_right = 1268
			
		last_direction = current_direction
			

func take_damage():
	if lives > 0:
		lives = lives -1
		update_lives.emit(lives, max_lives)
		print(lives)
		player_sprite.play("damage")
		set_physics_process(false)

func add_pickup(pickup):
	if pickup == Global.Pickups.HEALTH:
		if lives < max_lives:
			lives += 1
			update_lives.emit(lives, max_lives)
			print(lives)
			
		if pickup == Global.Pickups.ATTACK:
			pass
		
		if pickup == Global.Pickups.SCORE:
			pass
			
		
