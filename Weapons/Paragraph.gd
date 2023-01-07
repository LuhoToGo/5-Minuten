extends "res://Weapons/Projectile.gd"


func _collide(body: KinematicBody2D) -> void:
	if enemy_exited:
		if body != null:
			body.take_damage(2, knockback_direction, knockback_force)
		queue_free()
