extends State
class_name BFlyAttack

@export var attack_speed: float = 250.0  # Speed during attack
@export var attack_duration: float = 1.0  # Time spent dashing
@export var cooldown_time: float = 1.0  # Delay before attacking again

var attack_target: Vector2  # The position the fly dashes toward
var attacking: bool = false  # Track if attacking
var player_in_range = false
var player

@onready var player_detection = $"../../PlayerDetection"

func enter():
	object.velocity = Vector2.ZERO
	if player and player_in_range:
		attack_target = player.global_position  # Lock onto player's position
		attacking = true
		object.b_fly_anim.play("BFlyAttack")
		attack()
	else:
		print("ERROR: Player not detected when attack state started!")

func attack():
	if not attacking:
		return  # Prevent running if attack was canceled

	object.velocity = (attack_target - object.global_position).normalized() * attack_speed
	await get_tree().create_timer(attack_duration).timeout  # Attack duration
	
	object.velocity = Vector2.ZERO
	object.b_fly_anim.play("BFlyPatrol")
	
	await get_tree().create_timer(cooldown_time).timeout  # Cooldown before next attack
	
	change_state("BFlyPatrol")
	attacking = false


	object.b_fly_anim.play("BFlyPatrol")
	if player_in_range:
		change_state("BFlyAttack")  # Attack again if the player is still in range
	else:
		change_state("BFlyPatrol")  # Otherwise, return to patrol

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_in_range = true
		if not attacking:  # Only switch if not already attacking
			change_state("BFlyAttack")

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
