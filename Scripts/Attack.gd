extends ColorRect

@export var label: Label

func update_attack_boost(attack_time_left):
	label.text = str(attack_time_left)
