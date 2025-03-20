extends Control

@export var heart_container: Node  # The node holding the heart sprites
@export var full_heart_texture: Texture  # Texture for a full heart
@export var empty_heart_texture: Texture  # Texture for an empty heart

var max_health = 3  # Adjust based on your game's max health

func _ready():
	call_deferred("_connect_player")

func _connect_player():
	var player = get_tree().get_first_node_in_group("player")  
	if player:
		print("Player found! Connecting health_changed signal.")
		player.health_changed.connect(update_hearts)
		update_hearts(player.health)  
	else:
		print("No player found in group!")

func update_hearts(new_health):
	print("update_hearts called! New health:", new_health)  # Debug log
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i) as TextureRect
		if i < new_health:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture
