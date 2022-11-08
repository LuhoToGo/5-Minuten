extends KinematicBody2D

export var speed = 150.0
export var health = 3
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
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = direction.x > 0
		
		$AnimatedSprite.flip_v = false
	elif direction.y != 0:
		$AnimatedSprite.animation = "walk"
		#$Sprite.animation = "up"
		#$Sprite.flip_v = direction.y > 0
		#$AnimatedSpriteSprite.flip_h = false
	elif direction.x || direction.y == 0:
		$AnimatedSprite.animation = "idle"
	#position += direction * speed * delta
	var collision = move_and_collide(direction * speed * delta)
	if collision: print(collision.collider)
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
func damaged(amount):
	health_updated(health - amount)
	print(health)

func health_updated(new_health):
	print(health)
	health = new_health
	if health == 0:
		_die()

func _die():
	self.queue_free()

func shoot():
	var projectile = projectile_path.instance()
	
	projectile.position = $Weapon/Position2D.global_position
	#projectile.velocity = get_global_mouse_position()    -  projectile.position
	projectile.velocity = Vector2(300, 0).rotated($Weapon.rotation)
	projectile.rotation = $Weapon.rotation
	get_parent().add_child(projectile)
	#projectile.look_at(get_global_mouse_position())
	
	$FireRateTimer.start()
	yield(get_tree().create_timer(0.2), "timeout")
	if is_instance_valid(projectile):
		projectile.queue_free()
