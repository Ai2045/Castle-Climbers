extends ColorRect

@export var label: Label

func update_score(score):
	label.text = str(score)
