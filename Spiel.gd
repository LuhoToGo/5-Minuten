extends Node2D
onready var hero = $Hero
onready var heartbar = hero.get_child(8)
func _process(delta):
	var  hearts : float = (hero.health/float(100)) 
	heartbar.update_bar(hearts)

