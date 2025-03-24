extends State
class_name BFlyAttack

@export var attack_speed: float = 250.0  
@export var attack_duration: float = 1.0  
@export var cooldown_time: float = 1.0  

var attack_target: Vector2  
var attacking: bool = false  
var player_in_range = false
var player

@onready var player_detection = $"../../PlayerDetection"

func enter():
	object.velocity = Vector2.ZERO
	if player and player_in_range:
		attack_target = player.global_position  
		attacking = true
		object.anim.play("BFlyAttack")
		attack()
	else:
		print("ERROR: Player not detected when attack state started!")

func update(delta):
	if object.taking_damage:
		change_state("BFlyHurt")
		
func attack():
	if not attacking:
		return  

	object.velocity = (attack_target - object.global_position).normalized() * attack_speed
	await get_tree().create_timer(attack_duration).timeout  

	object.velocity = Vector2.ZERO
	object.anim.play("BFlyPatrol")
	
	await get_tree().create_timer(cooldown_time).timeout  

	change_state("BFlyPatrol")
	attacking = false

	object.anim.play("BFlyPatrol")
	if player_in_range:
		change_state("BFlyAttack")  
	else:
		change_state("BFlyPatrol")  

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_in_range = true
		if not attacking:  
			change_state("BFlyAttack")

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
