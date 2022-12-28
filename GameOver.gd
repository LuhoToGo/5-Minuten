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

<<<<<<< Updated upstream
func _on_AnimatedSprite_animation_finished():
	yield(get_tree().create_timer(3), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SavedData.reset_data()
	SceneTransistor.start_transition_to("res://Game.tscn")
=======
func _input(event: InputEvent) -> void:
	if animation_finished == true:
		if event.is_action_pressed("ui_down"):
			self.current_option += 1
		elif event.is_action_pressed("ui_up"):
			self.current_option -= 1
		if event.is_action_pressed("ui_accept"):
			match current_option:
				CONTINUE:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					SavedData.reset_data()
					SceneTransistor.start_transition_to("res://Game.tscn")
				EXIT:
					get_tree().quit()

func set_current_option(new_option: int) -> void:
	current_option = clamp(new_option, 0, $VBoxContainer.get_child_count()-1)
	$Sprite.position = $VBoxContainer.get_child(current_option).rect_global_position + Vector2(-10,
											$VBoxContainer.get_child(current_option).rect_size.y/2)
>>>>>>> Stashed changes
