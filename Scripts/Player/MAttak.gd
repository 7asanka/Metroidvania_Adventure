extends State
class_name MAttackState

@onready var m_attack_hitbox = $"../../MAttackHitbox"

func enter():
	object.MAttack_anim.play("MAttackEffect")  # Play attack animation
	m_attack_hitbox.monitoring = true  # Enable attack hitbox

	# Wait for the animation to finish before transitioning
	await object.MAttack_anim.animation_finished
	change_state("Idle")
	
func update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction < 0 :	
		object.get_node("AnimatedSprite2D").flip_h = true
		object.swordHitbox.position = Vector2(-19.5, -15)
	elif direction > 0:
		object.get_node("AnimatedSprite2D").flip_h = false
		object.swordHitbox.position = Vector2(19.5, -15)

func exit():
	m_attack_hitbox.monitoring = false  # Disable attack hitbox
