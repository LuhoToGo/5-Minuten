extends CanvasLayer

enum {NEW_GAME, CONTROLS,  EXIT}
var current_option: int = NEW_GAME setget set_current_option

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	
func _ready() -> void:
	self.current_option = 0
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		self.current_option += 1
	elif event.is_action_pressed("ui_up"):
		self.current_option -= 1
	if event.is_action_pressed("ui_accept"):
		$Music.stop()
		$Click.play()
		yield(get_tree().create_timer(1.0), "timeout")
		match current_option:
			NEW_GAME:
				
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				#get_tree().change_scene("res://Game.tscn")
				SceneTransistor.start_transition_to("res://Game.tscn")
			CONTROLS:
				get_tree().change_scene("res://Controls.tscn")
			EXIT:
				get_tree().quit()

func set_current_option(new_option: int) -> void:
	current_option = clamp(new_option, 0, $VBoxContainer.get_child_count()-1)
	$Sprite.position = $VBoxContainer.get_child(current_option).rect_global_position + Vector2(-10,
											$VBoxContainer.get_child(current_option).rect_size.y/2)
