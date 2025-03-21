extends Node

var player = null  # Store a reference to the player
var last_checkpoint

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
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		save_data = JSON.parse_string(file.get_as_text())
		file.close()
		print("Game loaded:", save_data)
		
		if save_data:
			print("✅ Game data loaded:", save_data)  # Debug print
		else:
			print("⚠ Error: Save file exists but could not be parsed!")
	else:
		print("⚠ No save file found, starting fresh.")

		# Restore Player Data
		if player:
			player.can_double_jump = save_data["player"].get("can_double_jump", false)
			player.max_health = save_data["player"].get("max_health", 3)
			player.health = player.max_health  # Restore full health
			player.global_position = Vector2(save_data["position"][0], save_data["position"][1])
			player.health_changed.emit(player.health)
			print("Player data restored:", save_data["player"])
			
func respawn_player():
	if player:
		player.respawn()

