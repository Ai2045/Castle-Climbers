extends Node2D

@export var body: AnimatedSprite2D
@export var speech_bubble: AnimatedSprite2D
@export var timer: Timer

@export var flip_h = false
@export var flip_v = false

func _ready():
	if flip_h == true and flip_v == true:
		speech_bubble.position.y +=40
	body.play("matching")

func _process(delta):
	
	body.flip_h = flip_h
	body.flip_v = flip_v
	speech_bubble.flip_h = flip_h
	speech_bubble.flip_v = flip_v
	
	timer.wait_time = randi_range(1, 10)
	
	if Global.is_bomb_moving == true:
		body.play("idle")
		speech_bubble.visible = true
		
	if Global.is_bomb_moving == false:
		body.play("matching")
		speech_bubble.visible = false
func _on_timer_timeout():
	var ramndom_speech = randi()%3
	match ramndom_speech:
		0:
			speech_bubble.play("boom")
		1:
			speech_bubble.play("loser")
		2:
			speech_bubble.play("swearing")
