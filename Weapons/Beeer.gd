extends Weapon

const CAP_SCENE: PackedScene = preload("res://Weapons/BottleCap.tscn")


func shoot(offset: int) -> void:
	var cap: Area2D = CAP_SCENE.instance()
	get_tree().current_scene.add_child(cap)
	cap.launch(global_position, Vector2.LEFT.rotated(deg2rad(rotation_degrees + offset)), 400)
	
	
func triple_shoot() -> void:
	shoot(0)
	shoot(12)
	shoot(-12)
