extends Control


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _on_git_hub_button_pressed():
	OS.shell_open("https://github.com/7asanka")

func _on_asset_button_pressed():
	OS.shell_open("https://o-lobster.itch.io/platformmetroidvania-pixel-art-asset-pack")

func _on_itch_page_pressed():
	OS.shell_open("https://7asanka.itch.io/metroidvania-adventure-demo")
