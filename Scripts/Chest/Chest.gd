extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var label = $Label

@export var ability_name = "double_jump"
@export var chest_id: String  # Unique ID for each chest

var is_open = false  # Track chest state

func _ready():
	# Load saved chest states
	var save_data = load_save_data()
	is_open = save_data.get("chests", {}).get(chest_id, false)  # Check if this chest is open

	# If chest was opened before, set it to open state
	if is_open:
		animated_sprite_2d.play("Open")
		collision_shape_2d.queue_free()
	else:
		animated_sprite_2d.play("Default")


func _on_body_entered(body):
	if body.is_in_group("player") and ability_name == "double_jump":
		animated_sprite_2d.play("Open")
		label.visible = true
		await animated_sprite_2d.animation_finished
		body.can_double_jump = true  # Grant the ability
		collision_shape_2d.queue_free()
		
		# 🔥 Save the chest state when it's opened
		save_chest_state()

		await get_tree().create_timer(3).timeout
		label.visible = false

func save_chest_state():
	# Load existing save data
	var save_data = load_save_data()

	# Ensure chests dictionary exists
	if "chests" not in save_data:
		save_data["chests"] = {}

	# Mark this chest as opened
	save_data["chests"][chest_id] = true

	# Save everything back to file
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

	print("Chest saved! Current save data:", save_data)  # Debug print

	# Debug print to check if saving worked
	print("Chest saved! Current save data:", save_data)

func load_save_data():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var text = file.get_as_text()
		file.close()
		
		if text.is_empty():
			return { "chests": {} }  # Return default if empty
		
		var save_data = JSON.parse_string(text)
		if save_data is Dictionary:
			return save_data

	# Return default structure if no save exists
	return { "chests": {} }
