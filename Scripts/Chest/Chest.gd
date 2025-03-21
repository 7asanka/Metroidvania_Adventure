extends Area2D

@export var ability_name: String = "double_jump"
@export var chest_id: String  # Unique ID for each chest

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var label = $Label

var is_open = false

func _ready():
	label.visible = false
	label.text = label.text.to_upper()
	# Load chest state from GameManager
	is_open = GameManager.save_data["chests"].get(chest_id, false)

	# If chest was opened before, set it to open state
	if is_open:
		animated_sprite_2d.play("Open")
		collision_shape_2d.queue_free()
	else:
		animated_sprite_2d.play("Default")

func _on_body_entered(body):
	if body.is_in_group("player") and not is_open:
		open_chest(body)

func open_chest(player):
	animated_sprite_2d.play("Open")
	label.visible = true
	await animated_sprite_2d.animation_finished

	# Grant ability if it's a double jump chest
	if ability_name == "double_jump":
		player.can_double_jump = true
		GameManager.save_data["player"]["can_double_jump"] = true

	collision_shape_2d.queue_free()

	# Save chest state in GameManager
	GameManager.save_data[chest_id] = true
	GameManager.save_game()

	await get_tree().create_timer(3).timeout
	label.visible = false
