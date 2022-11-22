extends Node2D
var player = null
func _process(delta):
	if player != null:
		look_at(player.position)
