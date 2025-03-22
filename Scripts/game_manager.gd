extends Node

var save_path = "user://savegame.sav"

var player_data = {
	"last_checkpoint": Vector2.ZERO,
	"max_health": 3,
	"can_double_jump": false
}

var chests = {}  # Tracks opened chests
var enemies = {}  # Tracks enemy positions

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var save_dict = {
		"player_data": player_data,
		"chests": chests,
		"enemies": enemies
	}
	file.store_var(save_dict)
	file.close()
	print("Game saved successfully.")

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var save_dict = file.get_var()
		file.close()

		# Load data if available
		player_data = save_dict.get("player_data", player_data)
		chests = save_dict.get("chests", {})
		enemies = save_dict.get("enemies", {})
		print("Game loaded successfully.")
	else:
		print("No save file found. Starting a new game.")

func respawn_player():
	if player_data["last_checkpoint"] != Vector2.ZERO:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.respawn()
