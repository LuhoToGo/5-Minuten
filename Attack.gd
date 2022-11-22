extends Node2D
var player_in_area = preload("res://Hero.tscn").instance()
func _process(_delta):
	look_at(player_in_area.position)
