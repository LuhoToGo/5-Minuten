extends Node2D

var player = null
var player_in_area = preload("res://Hero.tscn").instance()
func _process(_delta):
		if player != null:
			look_at(player.position)

