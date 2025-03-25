extends Node

const SAVE_FILE = "user://savegame.bin"

var player_data = {
	"max_health": 3,
	"current_health": 3,
	"can_double_jump": false,
	"last_checkpoint": Vector2.ZERO
}

var chests = {}  # Stores opened chests: { "chest_id": true }
var enemies = {}  # Stores enemy spawn positions: { "enemy_id": Vector2(x, y) }

func save_game():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var({
		"player_data": player_data,
		"chests": chests,
		"enemies": enemies
	})
	file.close()
	print("✅ Game saved successfully!")

func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		print("⚠ No save file found. Starting fresh.")
		return
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = file.get_var()
	file.close()

	# Restore player data
	player_data = data.get("player_data", player_data)
	chests = data.get("chests", chests)
	enemies = data.get("enemies", enemies)

	print("✅ Game loaded successfully!")

func reset_save():
	if FileAccess.file_exists(SAVE_FILE):
		player_data["last_checkpoint"] = Vector2.ZERO
		DirAccess.remove_absolute(SAVE_FILE)
		print("⚠ Save file deleted! Starting a new game.")
		
func respawn_player():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.respawn()
		reset_enemies()

func reset_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.reset()  # Call reset() on each enemy

