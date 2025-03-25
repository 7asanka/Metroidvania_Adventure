extends Control

@onready var resume = $Resume
@onready var quit = $Quit


func _on_resume_pressed():
	visible = false
	get_tree().paused = false

func toggle_pause():
	if get_parent().get_tree().paused == false:
		get_parent().get_tree().paused = true
	else:
		get_parent().get_tree().paused = false

func toggle_pause_menu():
	visible = get_tree().paused  # Pause menu should only be visible when the game is paused

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
