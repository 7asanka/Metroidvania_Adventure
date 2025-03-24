extends Area2D

@onready var player = $".."

func _on_body_entered(body):
	print("hit something")
	if body.is_in_group("enemy"):  # Check if it's an enemy
		print("hit an enemy")
		body.take_damage(player.attack_value) # Call enemy's take_damage() function
		body.velocity = (body.global_position - player.position).normalized() * Vector2(10, -300)
