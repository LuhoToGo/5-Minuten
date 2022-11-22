extends KinematicBody2D
var player_in_area = null
var direction = Vector2.ZERO
var speed = 150
export var health = 300
var collision = null
var only_once = true
enum states  {HIT, IDLE}
var state = states.IDLE
export var projectile_path =  preload("res://enemyprojectile.tscn")
var in_range = false

func _ready():
	$AnimatedSprite.modulate = Color(0, 0, 1) 

func _physics_process(delta):
	direction = Vector2.ZERO
	if in_range == true and $FireRateTimer.is_stopped() and states.IDLE:
		shoot()
	elif player_in_area != null && in_range == false:
		direction = position.direction_to(player_in_area.position)
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = direction.x > 0
		$AnimatedSprite.flip_v = false
	else:
		direction = Vector2.ZERO
		$AnimatedSprite.play("idle")
	direction = direction.normalized()
	collision = move_and_collide(direction*speed*delta)
	if collision && collision.collider.to_string().begins_with("Hero"):
		collision.collider.hit(100)

func shoot():
	var projectile = projectile_path.instance()
	projectile.position = $Attack/Position2D.global_position
	projectile.velocity = Vector2(300, 0).rotated($Attack.rotation)
	projectile.rotation = $Attack.rotation
	get_parent().add_child(projectile)
	$FireRateTimer.start()
	yield(get_tree().create_timer(1.5), "timeout")
	if is_instance_valid(projectile):
		projectile.queue_free()

func damaged(amount):
	$Hit.play()
	speed = 100
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
	if body.name == "Hero":
		player_in_area = body
		$Attack.player = body
		print("in")


func _on_Area2D_body_exited(body):
	if body.name == "Hero":
		player_in_area = null
		print("left")

func _die():
	self.queue_free()


func _on_Timer_timeout():
	only_once = true
	state = states.IDLE
	$HitEffect.play("idle")
	


func _on_Hit_Range_body_entered(body):
	if body.name == "Hero":
		in_range = true

func hit(value, cposition, dir):
	if only_once:
		move_and_collide(dir)
		damaged(value)
		


func _on_Hit_Range_body_exited(body):
	if body.name == "Hero":
		in_range = false
