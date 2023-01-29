extends Area2D

onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
onready var tween: Tween = get_node("Tween")
enum ACTIVE_ITEM {EMPTY, KREDITKARTE, TEXTMARKER, TABLETT}
const texture = preload("res://Art/Neu/Tablett.png")

func _on_MensaTablett_body_entered(player: KinematicBody2D) -> void:
	SavedData.item = 1
	$ItemPickUp.play()
	collision_shape.set_deferred("disabled", true)
	player.current_item = ACTIVE_ITEM.TABLETT
	player.dash_uses = 2
	player.item_change(texture)
	player.item_count("3")
	player.item_pickup("Tablett")
	#player.set_collision_mask_bit(3, false)
	#player.modulate.a = 0.5
	
	var __ = tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.interpolate_property(self, "position", position, position + Vector2.UP * 16, 0.6, Tween.TRANS_SINE, Tween.EASE_IN)
	assert(__)
	__ = tween.start()
	assert(__)


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()
