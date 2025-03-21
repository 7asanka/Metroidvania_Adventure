extends Node2D

@onready var player = $Player
@onready var hud_items = $HealthBar/HudItems

func _ready():
	GameManager.load_game()
	load_level_state()
	setup_signals()

func load_level_state():
	# Load player state
	player.global_position = GameManager.save_data["player"].get("position", Vector2.ZERO)
	player.health = GameManager.save_data["player"].get("max_health", 3)
	player.can_double_jump = GameManager.save_data["player"].get("can_double_jump", false)
	hud_items.update_hearts(player.health)

	# Load chests
	for chest in get_tree().get_nodes_in_group("chests"):
		chest.is_open = GameManager.chest_data.get(chest.chest_id, false)
		if chest.is_open:
			chest.animated_sprite_2d.play("Open")
			chest.collision_shape_2d.queue_free()
		else:
			chest.animated_sprite_2d.play("Default")

	# Load enemy positions only if they have an ID
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_method("reset") and "enemy_id" in enemy:
			if enemy.enemy_id in GameManager.save_data["enemy_positions"]:
				enemy.global_position = GameManager.save_data[enemy.enemy_id]
				enemy.reset()  # Reset to its patrol state

func setup_signals():
	# Connect HUD to player health updates
	player.health_changed.connect(hud_items.update_hearts)
	hud_items.update_hearts(player.health)

	# Connect checkpoints to game saving
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.checkpoint_reached.connect(GameManager.save_checkpoint)

	# Connect player to GameManager’s respawn method
	player.respawn_requested.connect(GameManager.respawn_player)
