extends Node2D

var enemy_start_positions = {}  # Dictionary to store original enemy positions

@onready var hud_items = $HealthBar/HudItems
@onready var player = $Player

func _ready():
	load_game()

func load_game():
	# Load save data if it exists
	
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var save_data = JSON.parse_string(file.get_as_text())
		file.close()
	
		# Make sure 'position' exists and is valid
		if save_data and "position" in save_data and typeof(save_data["position"]) == TYPE_ARRAY:
			var pos_array = save_data["position"]
			if pos_array.size() == 2:
				player.last_checkpoint = Vector2(pos_array[0], pos_array[1])  # Load saved position
				player.global_position = player.last_checkpoint  # Move player to checkpoint on game start
				print("Loaded checkpoint at:", player.last_checkpoint)
			else:
				print("Error: Invalid position data in save file.")
		else:
			print("No checkpoint found in save file.")
		player.can_double_jump = save_data.get("can_double_jump", false)
	# Ensure chests exist in the save data
		if "chests" not in save_data:
			save_data["chests"] = {}
		for chest in get_tree().get_nodes_in_group("chests"):
			chest.load_chest_state()
	for chest in get_tree().get_nodes_in_group("chests"):
		chest.load_chest_state()

	# Connect checkpoints to the player
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.checkpoint_reached.connect(player.save_checkpoint)

	player.health_changed.connect(hud_items.update_hearts)  
	hud_items.update_hearts(player.health)  # Ensure UI starts correctly
	print("HUD connected to player health updates!")
		
func save_enemy_positions():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy_start_positions[enemy.get_instance_id()] = enemy.global_position

func reset_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy_start_positions.has(enemy.get_instance_id()):
			enemy.global_position = enemy_start_positions[enemy.get_instance_id()]
			enemy.reset()  # Call enemy reset function if it exists
	print("Enemies reset to their original positions.")
