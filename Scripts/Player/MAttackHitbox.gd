extends Area2D


func _on_body_entered(body):
	print("hit something")
	if body.is_in_group("enemy"):  # Check if it's an enemy
		print("hit an enemy")
		body.take_damage() # Call enemy's take_damage() function
