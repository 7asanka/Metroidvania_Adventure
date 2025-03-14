extends CharacterBody2D

@onready var fsm = $MushFSM
@onready var anim = $AnimationPlayer

var health = 6
@onready var mush_anim = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	fsm.change_state("MushPatrol")

func _process(delta):
	fsm.update(delta)
	if health <= 0:
		await mush_anim.animation_finished
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y = gravity * delta
	fsm.physics_update(delta)
	move_and_slide()

func take_damage():
	fsm.change_state("MushHurt")
