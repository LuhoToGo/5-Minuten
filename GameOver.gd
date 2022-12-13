extends Control

func _on_Restart_pressed():
	SceneTransistor.start_transition_to("res://Game.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _ready():
	$AnimationPlayer.play("DeathScreen")

