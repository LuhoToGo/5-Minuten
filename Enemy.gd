extends KinematicBody2D

onready var navigation: Navigation2D = get_tree().current_scene.get_node("Rooms")

var player_in_area = null
var direction = Vector2.ZERO
var speed = 80
export var health = 300
var collision = null
var only_once = true


enum states  {HIT, IDLE, DASHING}
var state = states.IDLE
signal hit

func _ready():
	$AnimatedSprite.modulate = Color(0, 0, 1) 

func _physics_process(delta):

	$CollisionShape2D.disabled = false
	direction = Vector2.ZERO
	if player_in_area != null:
		direction = global_position.direction_to(player_in_area.global_position)
		$AnimatedSprite.play("walk")
		if player_in_area.global_position.x > global_position.x:

			$AnimatedSprite.flip_h = true
			$AnimatedSprite.flip_v = false
		else:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
	else:
		direction = Vector2.ZERO
		$AnimatedSprite.play("idle")
	direction = direction.normalized()
	collision = move_and_collide(direction*speed*delta)

	if collision && collision.collider.is_in_group("player"):
		#emit_signal("hit", 50)
		collision.collider.hit(100)

	#if  only_once && collision && collision.collider.to_string().begins_with("pro"):
		#direction = (self.position - collision.collider.position)
		#move_and_collide(direction*2)
		#damaged(100)
		
		#yield(get_tree().create_timer(0.3), "timeout")
		#$CollisionShape2D.disabled = false

func dash_attack():
	if state!=states.HIT:
		var start_position = self.global_position

		#state = states.DASHING
		#$HitEffect.play("attack")
		$AnimatedSprite.play("attack")
		speed = 500
		yield(get_tree().create_timer(0.1), "timeout")
		#state = states.IDLE
		speed = 80
		var this_direction = self.global_position-start_position

		move_and_collide(this_direction)

func damaged(amount):
	$Hit.play()
	speed = 80
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

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = null


func _die():
	self.queue_free()


func _on_Timer_timeout():
	only_once = true
	state = states.IDLE
	$HitEffect.play("idle")

func _on_Hit_Range_body_entered(body):
	if body.is_in_group("player") && state!=states.HIT:
		dash_attack()

func hit(value, cposition, dir):
	if only_once:
		#direction = (self.position - cposition)
		#move_and_collide(direction*2)
		move_and_collide(dir)

		damaged(value)
		
