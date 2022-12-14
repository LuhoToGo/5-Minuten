extends Hitbox
var enemy_exited: bool = false

func _ready():
	yield(get_tree().create_timer(40), "timeout")
	queue_free()


func _on_ThrowableKnike_body_exited(_body: KinematicBody) -> void:
	if not enemy_exited:
		enemy_exited = true
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)
		set_collision_mask_bit(3, true)

func _collide(body: KinematicBody2D) -> void:
	if enemy_exited:
		if body != null and not body.has_method("textmarker"):
			body.take_damage(damage, knockback_direction, knockback_force)
		#queue_free()
