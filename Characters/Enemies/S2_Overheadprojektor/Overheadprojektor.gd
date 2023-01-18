extends Enemy

var random_movement = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var speed = 2
onready var hitbox: Area2D = get_node("Hitbox")

func _process(_delta):
	hitbox.knockback_direction = velocity.normalized()
	if player.global_position > self.global_position:
		$AnimatedSprite.flip_h = true
		$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		$Hitbox/CollisionShape2D2.disabled = true
		$Hitbox.collision_shape = $Hitbox/CollisionShape2D
	else:
		$AnimatedSprite.flip_h = false
		$Hitbox/CollisionShape2D2.set_deferred("disabled", false)
		$Hitbox/CollisionShape2D.disabled = true
		$Hitbox.collision_shape = $Hitbox/CollisionShape2D2

func random_direction():
	var random_x = 0
	var random_y = 0
	rng.randomize()
	random_x = rng.randi_range(-5, 5)
	random_y = rng.randi_range(-5, 5)
	$MovementTimer.wait_time = rng.randf_range(0.4, 0.7)
	random_movement = Vector2(random_x, random_y)


func run():
	velocity = random_movement
	velocity = velocity.normalized()  
	var collision = move_and_collide(velocity*speed)
	if collision:
		random_direction()

