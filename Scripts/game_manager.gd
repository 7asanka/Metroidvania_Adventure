extends Node

var player = null  # Store a reference to the player
var last_checkpoint
var save_path = "user://savegame.json"

var save_data = {
	"checkpoint": null,
	"position": Vector2.ZERO,
	"player": {
		"max_health": 3,
		"can_double_jump": false
	},
	"chests": {},
	"enemy_positions": {}
}

func _ready():
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")
	
	# Load the game when the scene starts
	load_game()

func save_checkpoint(checkpoint_id: String, position: Vector2):
	last_checkpoint = position
	if player:
		save_data["checkpoint"] = checkpoint_id
		save_data["position"] = [position.x, position.y]  # Store position as an array
		save_data["player"]["can_double_jump"] = player.can_double_jump
		save_data["player"]["max_health"] = player.max_health
		save_game()
		print("Checkpoint saved at:", position)
		print("🔹 Saved data:", save_data)

func save_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved:", save_data)

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		save_data = JSON.parse_string(file.get_as_text())  
		file.close()

		# Ensure all necessary keys exist
		if "player" not in save_data:
			save_data["player"] = {"max_health": 3, "can_double_jump": false}

		if "chests" not in save_data:
			save_data["chests"] = {}

		if "enemy_positions" not in save_data:
			save_data["enemy_positions"] = {}

		# 🔥 Fix: Ensure 'position' exists and is loaded correctly
		if "position" in save_data and typeof(save_data["position"]) == TYPE_ARRAY and save_data["position"].size() == 2:
			player.last_checkpoint = Vector2(save_data["position"][0], save_data["position"][1])
			player.global_position = player.last_checkpoint  # Move player to the saved checkpoint
		else:
			print("Warning: No checkpoint position found in save file. Using default spawn.")

		# Load player stats
		player.max_health = save_data["player"].get("max_health", 3)
		player.can_double_jump = save_data["player"].get("can_double_jump", false)
		player.health = player.max_health
		player.health_changed.emit(player.health)

		# Load chests
		for chest in get_tree().get_nodes_in_group("chests"):
			if chest.chest_id in save_data["chests"]:
				chest.is_open = save_data["chests"][chest.chest_id]
				if chest.is_open:
					chest.animated_sprite_2d.play("Open")
					chest.collision_shape_2d.queue_free()

		# Load enemy positions
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.enemy_id in save_data["enemy_positions"]:
				enemy.global_position = Vector2(save_data["enemy_positions"][enemy.enemy_id][0], save_data["enemy_positions"][enemy.enemy_id][1])

		print("Game loaded successfully:", save_data)  # Debug print
	else:
		print("No save file found. Starting new game.")
		save_data = {
			"player": {"max_health": 3, "can_double_jump": false},
			"position": [0, 0],  # Default spawn
			"chests": {},
			"enemy_positions": {}
		}

func has_save():
	return FileAccess.file_exists("user://savegame.json")

func new_game():
	# Reset save data
	save_data = {
		"checkpoint": null,
		"position": [0, 0],  
		"player": { "max_health": 3, "can_double_jump": false },
		"chests": {},  
		"enemies": {}
	}
	save_game()

func respawn_player():
	if player:
		player.respawn()

