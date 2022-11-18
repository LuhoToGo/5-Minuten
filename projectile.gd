extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 300
var treffer = false
signal treffer
func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * speed * delta)
	if collision and is_instance_valid(self):
		if collision.collider.to_string().begins_with("En"):
			emit_signal("treffer", 100, position)
		yield(get_tree().create_timer(0.1), "timeout")
		queue_free()


