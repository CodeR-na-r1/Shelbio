extends Node2D

@onready var buttons = $buttons

func _on_play_pressed():
	buttons.play()
	await buttons.finished
	get_tree().change_scene_to_file("res://Game/level.tscn")

func _on_exit_pressed():
	buttons.play()
	await buttons.finished
	get_tree().quit()
