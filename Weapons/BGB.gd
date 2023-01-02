extends Weapon

const PARAGRAPH_SCENE: PackedScene = preload("res://Weapons/Paragraph.tscn")


func shoot(offset: int) -> void:
	$ShootSound.play()
	var paragraph: Area2D = PARAGRAPH_SCENE.instance()
	get_tree().current_scene.add_child(paragraph)
	paragraph.launch(global_position, Vector2.LEFT.rotated(deg2rad(rotation_degrees + offset)), 400)
	
	
func triple_shoot() -> void:
	shoot(0)
	shoot(12)
	shoot(-12)
