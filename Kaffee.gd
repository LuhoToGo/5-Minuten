extends Area2D



func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.pickup_passive_item("speed")
		self.queue_free()
