extends State
class_name MAttack

@onready var m_attack_hitbox = $"../../MAttackHitbox"

func enter():
	object.MAttack_anim.play("MAttackEffect")  # Play attack animation
	m_attack_hitbox.monitoring = true  # Enable attack hitbox

	# Wait for the animation to finish before transitioning
	await object.MAttack_anim.animation_finished
	change_state("Idle")

func exit():
	m_attack_hitbox.monitoring = false  # Disable attack hitbox
