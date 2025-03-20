extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 3
var max_health = 3
var attack_value = 1
var last_checkpoint = Vector2.ZERO  # Default spawn point

var can_double_jump = false
var has_double_jumped = false

signal health_changed(new_health)
@onready var anim = $AnimationPlayer
@onready var fsm = $FSM
@onready var MAttack_anim = $MAttackHitbox/AnimationPlayer
@onready var swordHitbox = $MAttackHitbox/CollisionShape2D #Swords hitbox
@onready var MAttackSprite = $MAttackHitbox/CollisionShape2D/AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fsm.change_state("Idle")
	add_to_group("player")

func _process(delta):
	fsm.update(delta)
	if Input.is_action_just_pressed("melle_attack"):
		fsm.change_state("MAttack")
	
	if health <= 0:
		get_tree().reload_current_scene()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		MAttackSprite.flip_h = false
	elif direction < 0:
		MAttackSprite.flip_h = true
		
	if Input.is_action_pressed("dash"):
		anim.play("Run")

	fsm.physics_update(delta)
	move_and_slide()

func take_damage(value):
	health -= value
	health_changed.emit(health)
	has_double_jumped = false  # Reset double jump when hit
	fsm.change_state("Hurt")
	print("Player took damage! Health:", health)

	#if health <= 0:
		#print("Player died! Respawning...")
		#respawn()


func respawn():
	if last_checkpoint != Vector2.ZERO:
		global_position = last_checkpoint  # Move the player to the last checkpoint
		print("Respawning player at:", last_checkpoint)
	else:
		print("No checkpoint found, respawning at default position.")

	health = max_health  # Restore full health
	health_changed.emit(health)

	# Reset enemies
	var level = get_tree().current_scene
	if level.has_method("reset_enemies"):
		level.reset_enemies()

func save_checkpoint(id, position):
	# Load existing save data
	var save_data = load_save_data()

	# Update only the checkpoint-related data
	save_data["checkpoint"] = id
	save_data["position"] = [position.x, position.y]
	save_data["can_double_jump"] = can_double_jump

	# Save back to file without removing chest data
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

	print("Checkpoint saved! Current save data:", save_data)  # Debug

func load_save_data():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var save_data = JSON.parse_string(file.get_as_text())
		file.close()
		if save_data:
			return save_data
	return {}  # Return empty dictionary if file doesn’t exist or is empty
