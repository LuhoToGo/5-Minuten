extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 300
var treffer = false
signal treffer
func _physics_process(delta):
	var dir = (velocity.normalized() * speed * delta)
	var collision = move_and_collide(dir)
	if collision and is_instance_valid(self):
		if collision.collider.to_string().begins_with("Hero"):
			#emit_signal("treffer", 100, position)
			collision.collider.hit(100)
		yield(get_tree().create_timer(0.1), "timeout")
		queue_free()


