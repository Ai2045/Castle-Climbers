extends Area2D

@export var sprite_animated:AnimatedSprite2D
@export var timer: Timer

var rotation_speed = 10
func _ready():
	sprite_animated.play("moving")

func _physics_process(delta):
	if Global.is_bomb_moving == true:
		sprite_animated.rotation += rotation_speed * delta
		
func _on_body_entered(body):
	if body.name == "Player":
		sprite_animated.play("explode")
		timer.start()
		Global.is_bomb_moving = false
		
		if Global.can_hurt == true:
			body.take_damage()
	
	if body.name == "Level" and ! body.name.begins_with("Platform"):
		sprite_animated.play("explode")
		timer.start()
		Global.is_bomb_moving = false


func _on_timer_timeout():
	if is_instance_valid(self):
		self.queue_free()
