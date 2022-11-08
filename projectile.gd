extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 300

func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * speed * delta)
	#if collision and is_instance_valid(self):
		#queue_free()

