extends State
class_name BFlyPatrol

@export var patrol_area_size: Vector2 = Vector2(100, 100)  # Defines the patrol range
@export var patrol_speed: float = 30.0  # Speed of movement

var target_position: Vector2
var start_position: Vector2  # Stores the fly's initial spawn position

func enter():
	start_position = object.global_position  # Save the starting position on entering patrol
	pick_new_target()

func physics_update(delta):
	if object.global_position.distance_to(target_position) < 10:  # Close enough to target
		pick_new_target()
	
	# Move towards target
	object.velocity = (target_position - object.global_position).normalized() * patrol_speed
	object.move_and_slide()

func pick_new_target():
	var min_x = start_position.x - patrol_area_size.x / 2
	var max_x = start_position.x + patrol_area_size.x / 2
	var min_y = start_position.y - patrol_area_size.y / 2
	var max_y = start_position.y + patrol_area_size.y / 2

	target_position = Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)


func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		object.chasing = true
		change_state("BFlyAttack")
