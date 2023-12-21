extends Node

@onready var winMenu = $"../CanvasLayer/WinMenu"
@onready var pauseMenu = $"../CanvasLayer/PauseMenu"
@onready var buttons = $"../buttons"

var gameFinished: bool = false
var gamePaused: bool = false
var changed: bool = false

func _ready():
	Signals.connect("levelCompleted", Callable(self, "_levelCompleted"))

func _process(delta):
	if gameFinished == false:
		if Input.is_action_just_pressed("pause") or changed == true:
			gamePaused = !gamePaused
			get_tree().paused = gamePaused
			changed = false
			
		if gamePaused == true:
			pauseMenu.show()
		else:
			pauseMenu.hide()
			
		winMenu.hide()
	else:
		winMenu.show()

func _levelCompleted():
	print("Signal")
	gameFinished = true
	winMenu.show()
	gamePaused = !gamePaused
	get_tree().paused = gamePaused
	
func _on_resume_pressed():
	buttons.play()
	await buttons.finished
	changed = true

func _on_return_pressed():
	buttons.play()
	await buttons.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/menu.tscn")


func _on_exit_pressed():
	buttons.play()
	await buttons.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/menu.tscn")
