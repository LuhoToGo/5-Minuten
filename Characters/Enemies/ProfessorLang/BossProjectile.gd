extends Hitbox

var enemy_exited: bool = true

var direction: Vector2 = Vector2.ZERO
var projectile_speed: int = 0
var rotation_speed = 1
var should_rotate = true
func _ready():
	$Timer.start()
	#$queuefreeTimer.start()
	
func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	projectile_speed = speed
	rotation += dir.angle() + PI/4
	
func _physics_process(delta: float) -> void:
	position += direction * projectile_speed * delta
	rotation_degrees +=rotation_speed
	if should_rotate:
		rotation_speed += 0.1



func _on_ThrowableKnike_body_exited(_body: KinematicBody) -> void:
	if not enemy_exited:
		enemy_exited = true
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)
		set_collision_mask_bit(3, true)


func _collide(body: KinematicBody2D) -> void:
	if enemy_exited:
		if body != null:
			body.take_damage(1, knockback_direction, knockback_force)
			print(body)
		queue_free()


func _on_Timer_timeout():
	projectile_speed = 185


#func _on_queuefreeTimer_timeout():
	#self.queue_free()
