extends Control

@onready var continue_button = $ContinueButton

func _ready():
	# Disable "Continue" if no save exists
	if not GameManager.has_save():
		continue_button.disabled = true

func _on_new_game_button_pressed():
	# Start a new game (clear save and load level 1)
	GameManager.new_game()
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	
func _on_continue_button_pressed():
	# Load last checkpoint
	GameManager.load_game()
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()



