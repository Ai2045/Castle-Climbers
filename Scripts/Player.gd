extends CharacterBody2D

signal update_lives(lives, max_lives)
signal update_attack_boost(attack_time_left)
signal update_score(score)

@export var max_lives = 3
@export var lives = 3
@export var speed = 100
@export var gravity = 200
@export var jump_height = -150
@export var score = 0
var is_hurt = false

var last_direction = 0
var current_direction = 0

@export var player_sprite: AnimatedSprite2D
@export var player_collisionShape: CollisionShape2D
@export var animation_player: AnimationPlayer
@export var offset_camera: Camera2D
@export var health: ColorRect
@export var health_label: Label
@export var attack: ColorRect
@export var attack_boost_timer: Timer
@export var attack_rayCast:RayCast2D
@export var score_rayCast: RayCast2D
@export var score_ui: ColorRect

var attack_time_left = 0

func _ready():
	current_direction = -1
	attack_time_left = attack_boost_timer.wait_time
	print(attack_time_left)
	update_lives.connect(health.update_lives)
	update_attack_boost.connect(attack.update_attack_boost)
	update_score.connect(score_ui.update_score)
	health_label.text = str(lives)
	
func _physics_process(delta):
	
	velocity.y += gravity * delta
	horizontal_movement()
	move_and_slide()
	
	if Global.is_climbing == false:
		player_animations()
	
	if Global.is_attacking == true:
		attack_time_left = max(0, attack_time_left -1)
		update_attack_boost.emit(attack_time_left)
		
		var target = attack_rayCast.get_collider()
		if target != null:
			if target.name == "Box" and Input.is_action_pressed("ui_attack"):
				Global.disable_spawning()
				target.queue_free()
				increase_score(10)
			if target.name == "Bomb" and Input.is_action_pressed("ui_attack"):         
				Global.is_bomb_moving = false
				increase_score(10)
			Global.can_hurt = false
		else :
			Global.can_hurt = true
	
	if Input.is_action_pressed("ui_jump"):
		var target = score_rayCast.get_collider()
		
		if target != null:
			if target.name == "Box" or target.name == "Bomb":
				if is_hurt == false:
					increase_score(1)

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
		if Global.is_attacking == true:
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
	if attack_time_left <= 0:
		Global.is_attacking = false
	Global.is_climbing = false
	set_physics_process(true)
	is_hurt = false

func _process(delta):
	if velocity.x > 0:
		current_direction = 1
	elif velocity.x < 0:
		current_direction = -1
	
	if current_direction != last_direction:
		if current_direction == 1:
			
			offset_camera.limit_left = -110
			offset_camera.limit_bottom = 705
			offset_camera.limit_top = 40
			offset_camera.limit_right = 1068
			
			animation_player.play("move_right")
			
			attack_rayCast.target_position.x = 50
			
		elif current_direction == -1:
			
			offset_camera.limit_left = 90
			offset_camera.limit_bottom = 705
			offset_camera.limit_top = 40
			offset_camera.limit_right = 1268
			
			animation_player.play("move_left")
			
			attack_rayCast.target_position.x = -50
			
		last_direction = current_direction
			

func take_damage():
	if lives > 0 and Global.can_hurt == true:
		lives = lives -1
		update_lives.emit(lives, max_lives)
		player_sprite.play("damage")
		set_physics_process(false)
		is_hurt = true
	
		decrease_score(10)

func add_pickup(pickup):
	if pickup == Global.Pickups.HEALTH:
		if lives < max_lives:
			lives += 1
			update_lives.emit(lives, max_lives)
			
	if pickup == Global.Pickups.ATTACK:
		Global.is_attacking = true
		
	if pickup == Global.Pickups.SCORE:
		increase_score(1000)
			
		


func _on_attack_boost_timer_timeout():
	if attack_time_left <= 0:
		Global.is_attacking = false
		Global.can_hurt = true

func increase_score(score_count):
	score += score_count
	update_score.emit(score)
	
func decrease_score(score_count):
	if score >= score_count:
		score -= score_count
		update_score.emit(score)
