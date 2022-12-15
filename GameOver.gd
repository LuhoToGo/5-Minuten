extends CanvasLayer

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)

func _ready():
	$TextureRect/AnimatedSprite.frame = 0
	yield(get_tree().create_timer(1.2), "timeout")
	$TextureRect/AnimatedSprite.play("gameover")

func _on_AnimatedSprite_animation_finished():
				#get_tree().change_scene("res://Game.tscn")
	yield(get_tree().create_timer(3), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SceneTransistor.start_transition_to("res://Game.tscn")
