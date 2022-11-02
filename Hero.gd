extends KinematicBody2D

export var speed = 150.0
const projectile_path =  preload("res://projectile.tscn")
#var screen_size = Vector2.ZERO

#func _ready():
	#screen_size = get_viewport_rect().size

func _process(delta):
	var direction =Vector2.ZERO
	if Input.is_action_pressed("shoot") and $FireRateTimer.is_stopped():
		shoot()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if direction.length() > 0:
		direction = direction.normalized()
		#$Sprite.play()
		
	if direction.x != 0:
		#$Sprite.animation = "right"
		$Sprite.flip_h = direction.x > 0
		
		#$Sprite.flip_v = false
	elif direction.y != 0:
		#$Sprite.animation = "up"
		#$Sprite.flip_v = direction.y > 0
		$Sprite.flip_h = false
	#position += direction * speed * delta
	move_and_collide(direction*speed*delta)
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
func shoot():
	var projectile = projectile_path.instance()
	get_parent().add_child(projectile)
	projectile.position = $Node2D/Position2D.global_position
	projectile.velocity = get_local_mouse_position() -  projectile.position
	#projectile.look_at(get_global_mouse_position())
	projectile.rotation = $Node2D.rotation
	$FireRateTimer.start()
	yield(get_tree().create_timer(0.2), "timeout")
	if is_instance_valid(projectile):
		projectile.queue_free()
