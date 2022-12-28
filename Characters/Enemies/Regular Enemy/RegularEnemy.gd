extends Enemy

onready var hitbox: Area2D = get_node("Hitbox")

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	if player.global_position > self.global_position and player_visible == true:
		$AnimatedSprite.flip_h = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		$Hitbox/CollisionShape2D2.disabled = true
		$Hitbox.collision_shape = $Hitbox/CollisionShape2D
	elif player_visible == true:
		$AnimatedSprite.flip_h = false
		$Hitbox/CollisionShape2D2.set_deferred("disabled", false)
		$Hitbox/CollisionShape2D.disabled = true
		$Hitbox.collision_shape = $Hitbox/CollisionShape2D2
