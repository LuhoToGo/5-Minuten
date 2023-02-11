extends Area2D
enum ACTIVE_ITEM {EMPTY, KREDITKARTE, TEXTMARKER, TABLETT}
onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
onready var tween: Tween = get_node("Tween")
const texture = preload("res://Art/Neu/Textmarker.png")

func _on_Textmarker_body_entered(player: KinematicBody2D) -> void:
	SavedData.item = 3
	$ItemPickUp.play()
	player.item_pickup("Textmarker\nDas Highlight meines Studiums")
	collision_shape.set_deferred("disabled", true)
	player.current_item = ACTIVE_ITEM.TEXTMARKER
	player.item_change(texture)
	var __ = tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.interpolate_property(self, "position", position, position + Vector2.UP * 16, 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.start()
	assert(__)
	
	
func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()


