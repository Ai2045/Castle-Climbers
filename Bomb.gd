extends Area2D

@export var sprite_animated:AnimatedSprite2D
@export var timer: Timer

func _ready():
	sprite_animated.play("moving")

func _on_body_entered(body):
	if body.name == "Player":
		sprite_animated.play("explode")
		timer.start()
	
	if body.name == "Level":
		sprite_animated.play("explode")
		timer.start()


func _on_timer_timeout():
	if is_instance_valid(self):
		self.queue_free()
