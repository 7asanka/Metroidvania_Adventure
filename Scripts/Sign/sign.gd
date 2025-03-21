extends Area2D

@onready var label = $Label

@export var text: String = "place holder"

func _ready():
	label.visible = false
	label.text = text.to_upper()
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		label.visible = false
