extends Area2D

onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
onready var tween: Tween = get_node("Tween")

func _on_Kaffe_body_entered(player: KinematicBody2D) -> void:
	$ItemPickUp.play()
	collision_shape.set_deferred("disabled", true)
	player.max_speed += 50
	SavedData.speed = 180
	
	var __ = tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.interpolate_property(self, "position", position, position + Vector2.UP * 16, 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.start()
	assert(__)
	
	
func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()


