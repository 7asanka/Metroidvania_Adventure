extends Node2D

@onready var player = $Player
@onready var hud_items = $HealthBar/HudItems

func _ready():
	SaveManager.load_game()
	load_level_state()
	setup_signals()

func load_level_state():
	# Load player state
	player.global_position = SaveManager.player_data.get("last_checkpoint", Vector2.ZERO)
	player.health = SaveManager.player_data.get("max_health", 3)
	player.can_double_jump = SaveManager.player_data.get("can_double_jump", false)
	hud_items.update_hearts(player.health)

	# Load chests
	for chest in get_tree().get_nodes_in_group("chests"):
		chest.is_open = SaveManager.chests.get(chest.chest_id, false)
		if chest.is_open:
			chest.animated_sprite_2d.play("Open")
			chest.collision_shape_2d.queue_free()
		else:
			chest.animated_sprite_2d.play("Default")

	# Load enemy positions
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_method("reset") and enemy.enemy_id in SaveManager.enemies:
			enemy.global_position = SaveManager.enemies[enemy.enemy_id]
			enemy.reset()

func setup_signals():
	# Connect HUD to player health updates
	player.health_changed.connect(hud_items.update_hearts)
	hud_items.update_hearts(player.health)

	# Connect player to respawn method
	player.respawn_requested.connect(SaveManager.respawn_player.bind())
