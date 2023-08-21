extends Area2D

@export var animated_sprite: AnimatedSprite2D

func _ready():
	animated_sprite.play("moving")
	
func _on_body_entered(body):
	if body.name == "Player":
		animated_sprite.play("explode")
		Global.disable_spawning()
		
		body.take_damage()
		
	if body.name.begins_with("wall"):
		queue_free()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "explode":
		queue_free()
