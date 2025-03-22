extends Area2D

@export var checkpoint_id: String
@onready var anim = $AnimationPlayer
@onready var e_key_sprite = $EKeySprite
@onready var label = $Label

var can_check = false
var player = null

func _ready():
	label.visible = false
	label.text = label.text.to_upper()
	anim.play("default")

func _process(delta):
	if Input.is_action_just_pressed("interact") and can_check:
		use_checkpoint()

func _on_body_entered(body):
	if body.is_in_group("player"):
		e_key_sprite.visible = true
		can_check = true
		player = body

func use_checkpoint():
	if player:
		player.save_checkpoint(global_position)
		anim.play("newSave")
		label.visible = true
		player.health = player.max_health
		player.health_changed.emit(player.max_health)
		SaveManager.reset_enemies()  # 🔹 Reset enemies when activating checkpoint
		await anim.animation_finished
		anim.play("default")
		await get_tree().create_timer(1).timeout
		label.visible = false

func _on_body_exited(body):
	if body.is_in_group("player"):
		e_key_sprite.visible = false
		can_check = false
