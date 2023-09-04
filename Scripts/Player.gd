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
@export var time_label: Label
@export var level: Label
@export var gameOver_menu: ColorRect
@export var UI: CanvasLayer
@export var final_time: Label
@export var final_score: Label
@export var final_rating: Label
@export var pause_menu: CanvasLayer

@export var instructions: Popup

@export var background_music: AudioStreamPlayer
@export var pauseMenu_music:AudioStreamPlayer
@export var gameOver_music: AudioStreamPlayer
@export var jumpSFX: AudioStreamPlayer
@export var damageSFX: AudioStreamPlayer
@export var healthSFX: AudioStreamPlayer
@export var scoreSFX: AudioStreamPlayer
@export var boostSFX: AudioStreamPlayer
@export var attackSFX: AudioStreamPlayer
@export var increaseScoreSFX: AudioStreamPlayer

@export var runningParticles: GPUParticles2D

var attack_time_left = 0

var level_start_time = Time.get_ticks_msec()

func _ready():
	
	current_direction = -1
	attack_time_left = attack_boost_timer.wait_time
	print(attack_time_left)
	update_lives.connect(health.update_lives)
	update_attack_boost.connect(attack.update_attack_boost)
	update_score.connect(score_ui.update_score)
	health_label.text = str(lives)
	
	if Global.get_current_level_number() == 1:
		set_process(false)
		instructions.visible = true
	else:
		level_start_time = Time.get_ticks_msec()
		
	background_music.play()
	
func _physics_process(delta):
	
	velocity.y += gravity * delta
	horizontal_movement()
	move_and_slide()
	
	if Global.is_climbing == false:
		player_animations()
	
	if Global.is_attacking == true:
		attack_time_left = max(0, attack_time_left -1)
		update_attack_boost.emit(attack_time_left)
		
		if Input.is_action_just_pressed("ui_attack"):
			var target = attack_rayCast.get_collider()
			
			if target != null:
				if target.name == "Box" :
					Global.disable_spawning()
					target.queue_free()
					increase_score(10)
					
				if target.name == "Bomb":         
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
		score_rayCast.position.x = 5
		
		runningParticles.emitting = true
		runningParticles.process_material.gravity = Vector3(10,-2,0)
		runningParticles.position.x = 5
		
	if Input.is_action_pressed("ui_right") && Global.is_jumping == false:
		player_sprite.flip_h = false
		player_sprite.play("run")
		player_collisionShape.position.x = -7
		score_rayCast.position.x = -5
		
		runningParticles.emitting = true
		runningParticles.process_material.gravity = Vector3(-10,-2,0)
		runningParticles.position.x = -5
		
	if !Input.is_anything_pressed():
		player_sprite.play("idle")
		runningParticles.emitting = false

func _input(event):
	
	if event.is_action_pressed("ui_pause"):
		get_tree().paused = true
		pause_menu.visible = true
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		background_music.stop()
		pauseMenu_music.play()
		
	if event.is_action_pressed("ui_attack"):
		if Global.is_attacking == true:
			player_sprite.play("attack")
			attackSFX.play()
		
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		player_sprite.play("jump")
		jumpSFX.play()
		runningParticles.emitting = true
		
	if Global.is_climbing == true:
		if !Input.is_anything_pressed():
			player_sprite.play("idle")
			runningParticles.emitting = false
			
		if Input.is_action_pressed("ui_up"):
			player_sprite.play("climb")
			gravity = 100
			velocity.y = -160
			Global.is_jumping = true
			jumpSFX.play()
			
	else:
			gravity = 200
			Global.is_climbing = false  
			Global.is_jumping = false

func _on_animated_sprite_2d_animation_finished():
	if attack_time_left <= 0:
		Global.is_attacking = false
		
	set_physics_process(true)
	is_hurt = false
	
	if player_sprite.animation == "death":
		get_tree().paused = true
		gameOver_menu.visible = true
		animation_player.play("ui_visibility")
		UI.visible = false
		final_score_time_and_rating()
		
		final_time.text = str(Global.final_time)
		final_score.text = str(Global.final_score)
		final_rating.text = str(Global.final_rating)
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		background_music.stop()
		gameOver_music.play()

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
			
	if get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif get_tree().paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		update_time_label()
	

func take_damage():
	if lives > 0 and Global.can_hurt == true:
		lives = lives -1
		update_lives.emit(lives, max_lives)
		player_sprite.play("damage")
		set_physics_process(false)
		is_hurt = true
	
		decrease_score(10)
		damageSFX.play()
		
	if lives <= 0:
		player_sprite.play("death")

func add_pickup(pickup):
	if pickup == Global.Pickups.HEALTH:
		if lives < max_lives:
			lives += 1
			update_lives.emit(lives, max_lives)
		healthSFX.play()
		
	if pickup == Global.Pickups.ATTACK:
		Global.is_attacking = true
		boostSFX.play()
		
	if pickup == Global.Pickups.SCORE:
		increase_score(1000)
		scoreSFX.play()
			
		


func _on_attack_boost_timer_timeout():
	if attack_time_left <= 0:
		Global.is_attacking = false
		Global.can_hurt = true

func increase_score(score_count):
	score += score_count
	update_score.emit(score)
	increaseScoreSFX.play()
	
func decrease_score(score_count):
	if score >= score_count:
		score -= score_count
		update_score.emit(score)

func final_score_time_and_rating():
	var time_taken = (Time.get_ticks_msec() - level_start_time) /1000.0
	var time_rounded = str(roundf(time_taken)) + " secs"
	
	var rating = ""
	
	if time_taken <= 60 and score >= 10000:
		rating = "Master" # Exceptionally high score and fast completion
	elif time_taken <= 120 and score >= 5000:
		rating = "Pro" # Very high score and fast completion
	elif time_taken <= 180 and score >= 3000:
		rating = "Expert" # High score and moderately fast completion
	elif time_taken <= 240 and score >= 2000:
		rating = "Intermediate" # Good score and completion time
	elif time_taken <= 300 and score >= 1000:
		rating = "Amateur" # Decent score, but not very fast
	else:
		rating = "Beginner" # All other cases
		
	Global.final_score = score
	Global.final_time = time_rounded
	Global.final_rating = rating

func update_time_label():
	var time_passed = (Time.get_ticks_msec() - level_start_time) /1000.0
	time_label.text = str(round(time_passed)) + "s"
	
func update_level_label():
	var current_level = Global.get_current_level_number()
	if current_level != -1:
		level.text = " " + str(current_level)
	else:
		level.text = "err"


func _on_restart_button_pressed():
	if Global.get_current_level_number() > 1:
		get_tree().paused = false
		
	gameOver_menu.visible = false
	get_tree().reload_current_scene()
	
	background_music.play()
	


func _on_button_resume_pressed():
	get_tree().paused = false
	pause_menu.visible = false
	
	background_music.play()
	pauseMenu_music.stop()


func _on_button_save_pressed():
	Global.save_game()


func _on_button_load_pressed():
	var current_scene = get_tree().root.get_tree().current_scene
	
	if current_scene:
		current_scene.queue_free()
	
	Global.load_game()
	get_tree().paused = false


func _on_button_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")


func _on_accept_button_pressed():
	instructions.visible = false
	
	get_tree().paused = false
	set_process(true)
	level_start_time = Time.get_ticks_msec()
