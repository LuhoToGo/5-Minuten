extends Node2D

func _init() -> void:
	randomize()
	
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		get_tree().paused = true

func _ready() -> void:
	$Player.current_weapon.connect("attackshake", self, "_on_weapon_used")
	if SavedData.num_floor == 1:
		$Hintergrundmusik1.play()
	elif SavedData.num_floor == 2:
		$Hintergrundmusik2.play()
	elif SavedData.num_floor == 3:
		$Hintergrundmusik3.play()
	elif SavedData.num_floor == 4:
		$HintergrundmusikBoss.play()
	
func _on_weapon_used():
	#$Camera2D.get_child(0).start(0.2, 15, 16, 0)
	#$Camera2D.get_child(0)._new_shake()
	$Camera2D.get_child(0).start()
