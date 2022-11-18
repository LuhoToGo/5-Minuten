extends Node2D

var custom_mouse_position: Vector2
func _process(delta):
	custom_mouse_position = lerp(custom_mouse_position, get_global_mouse_position(), 0.3)
	#look_at(get_global_mouse_position())
	look_at(custom_mouse_position)
