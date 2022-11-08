extends KinematicBody2D
var player_in_area = null
var direction = Vector2.ZERO
var speed = 1
export var health = 300
var collision = null
var only_once = true
func _ready():
	$AnimatedSprite.modulate = Color(0, 0, 1) 

func _physics_process(delta):
	$CollisionShape2D.disabled = false
	direction = Vector2.ZERO
	if player_in_area != null:
		direction = position.direction_to(player_in_area.position) * speed
		$AnimatedSprite.play("walk")
		if player_in_area.position.x > position.x:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.flip_v = false
		else:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
	else:
		direction = Vector2.ZERO
		$AnimatedSprite.play("idle")
	direction = direction.normalized()
	collision = move_and_collide(direction)
	if  only_once && collision && collision.collider.to_string().begins_with("pro"):
		damaged(100)
		only_once = false
		$Timer.start()
		#yield(get_tree().create_timer(0.3), "timeout")
		#$CollisionShape2D.disabled = false

func damaged(amount):
	health_updated(health - amount)
	print(health)

func health_updated(new_health):
	print(health)
	health = new_health
	if health == 0:
		_die()

func _on_Area2D_body_entered(body):
	if body.name == "Hero":
		print(body.name)
		player_in_area = body


func _on_Area2D_body_exited(body):
	player_in_area = null

func _die():
	self.queue_free()


func _on_Timer_timeout():
	only_once = true
