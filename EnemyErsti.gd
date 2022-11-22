extends KinematicBody2D
var player_in_area = null
var direction = Vector2.ZERO
var speed = 250
export var health = 200
var collision = null
var only_once = true
enum states  {HIT, IDLE}
var state = states.IDLE
var rng = RandomNumberGenerator.new()
var random_movement = Vector2.ZERO


func _ready():
	$AnimatedSprite.modulate = Color(0, 0, 1) 
	


func _physics_process(delta):
	#direction = Vector2.ZERO
	direction = random_movement
	if player_in_area != null:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = direction.x > 0
		$AnimatedSprite.flip_v = false
	else:
		direction = Vector2.ZERO
		$AnimatedSprite.play("idle")
	direction = direction.normalized()
	collision = move_and_collide(direction*speed*delta)
	if collision:
		random_direction()
		if collision.collider.is_in_group("player"):
			collision.collider.hit(100)

func random_direction():
	var random_x = 0
	var random_y = 0
	rng.randomize()
	random_x = rng.randi_range(-5, 5)
	random_y = rng.randi_range(-5, 5)
	$MovementTimer.wait_time = rng.randf_range(0.4, 0.7)
	random_movement = Vector2(random_x, random_y)

func damaged(amount):
	$Hit.play()
	speed = 250
	only_once = false
	state = states.HIT
	$HitTimer.start()
	$HitEffect.play("flash")
	health_updated(health - amount)
	print(health)

func health_updated(new_health):
	print(health)
	health = new_health
	if health == 0:
		_die()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print(body.name)
		player_in_area = body


func _die():
	self.queue_free()


func _on_Timer_timeout():
	only_once = true
	state = states.IDLE
	$HitEffect.play("idle")
	


func hit(value, cposition, dir):
	if only_once:
		move_and_collide(dir)
		damaged(value)
		
