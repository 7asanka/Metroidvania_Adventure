extends State
class_name MushPatrol

const SPEED = 50  # Adjust speed as needed
var direction = -1  # Start moving left

@onready var wall_check = $"../../WallCheck"
@onready var wall_check_2 = $"../../WallCheck2"
@onready var ground_check = $"../../GroundCheck"
@onready var ground_check_2 = $"../../GroundCheck2"

func enter():
	object.mush_anim.play("MushWalk")

func update(delta):
	# Check for walls or missing ground
	var should_turn = false
	
	if wall_check.is_colliding() or not ground_check.is_colliding():
		should_turn = direction == 1  # Only turn if moving right
	elif wall_check_2.is_colliding() or not ground_check_2.is_colliding():
		should_turn = direction == -1  # Only turn if moving left
	
	if should_turn:
		direction *= -1
	
	object.get_node("AnimatedSprite2D").flip_h = (direction == -1)  # Flip sprite properly
		
func physics_update(delta):
	object.velocity.x = direction * SPEED
	object.move_and_slide()


