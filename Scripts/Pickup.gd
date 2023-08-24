@tool
extends Area2D

@export var pickup: Global.Pickups

var health_texture = preload("res://Assets/heart/heart/sprite_0.png")
var score_texture = preload("res://Assets/star/star/sprite_04.png")
var attack_boost_texture = preload("res://Assets/lightning bolt/lightning bolt/sprite_0.png")

@onready var my_label = get_node("MyLabel")
@export var pickup_texture:Sprite2D

func _ready():
	if pickup == Global.Pickups.HEALTH:
		pickup_texture.set_texture(health_texture)
	elif pickup == Global.Pickups.SCORE:
		pickup_texture.set_texture(score_texture)
	elif pickup == Global.Pickups.ATTACK:
		pickup_texture.set_texture(attack_boost_texture)

func _process(delta):
	if Engine.is_editor_hint():
		if pickup == Global.Pickups.HEALTH:
			pickup_texture.set_texture(health_texture)
		elif pickup == Global.Pickups.SCORE:
			pickup_texture.set_texture(score_texture)
		elif pickup == Global.Pickups.ATTACK:
			pickup_texture.set_texture(attack_boost_texture)
			

func _on_body_entered(body):
	if body.name == "Player":
		body.add_pickup(pickup)
		get_tree().queue_delete(self)
		
