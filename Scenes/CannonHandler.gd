extends Node2D

@export var body: AnimatedSprite2D
@export var speech_bubble: AnimatedSprite2D
@export var timer: Timer

func _ready():
	body.play("matching")

func _process(delta):
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
