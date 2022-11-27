extends KinematicBody2D

onready var parent: Node2D = get_parent()
export var speed = 180.0
export var health = 300
var only_once = true
var longevity = 0.25
const projectile_long_path =  preload("res://projectile_long.tscn")
export var projectile_path =  preload("res://projectile.tscn")
enum states  {HIT, IDLE}
var state = states.IDLE
onready var dust_position: Position2D = get_node("DustPosition")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var animation_player: AnimationPlayer = get_node("HitEffect")

const DUST_SCENE: PackedScene = preload("res://Dust.tscn")

#var screen_size = Vector2.ZERO

#func _ready():
	#screen_size = get_viewport_rect().size

func _process(delta):
	var direction =Vector2.ZERO
	if Input.is_action_just_pressed("shoot") and $FireRateTimer.is_stopped():
		shoot()
		#screenshake()
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
		#$AnimatedSprite.animation = "walk"
		animation_player.play("walk")
		$AnimatedSprite.flip_h = direction.x > 0
		
		$AnimatedSprite.flip_v = false
	elif direction.y != 0:
		#$AnimatedSprite.animation = "walk"
		#$AnimatedSprite.animation = "up"
		animation_player.play("up")
		#$Sprite.flip_v = direction.y > 0
		#$AnimatedSpriteSprite.flip_h = false
	elif direction.x || direction.y == 0:
		$AnimatedSprite.animation = "idle"
	#position += direction * speed * delta

	var collision = move_and_collide(direction * speed * delta)
	#if collision: print(collision.collider)
	if  only_once && collision && collision.collider.to_string().begins_with("Enemy"):
		print("mmm")

	#	damaged(50)
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
func hit(value):
	if only_once && states.IDLE:
		damaged(value)

func damaged(amount):
	$HitSound.play()
	$HitInvunerable.start()
	$CollisionShape2D.disabled = true
	#set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	only_once = false
	health_updated(health - amount)
	$HitEffect.play("flash")
	
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
	$ProjectileSound.play()
	$Camera2D.add_trauma(0.25)
	$Camera2D.shake()
	projectile.position = $Weapon/Position2D.global_position
	#projectile.velocity = get_global_mouse_position()    -  projectile.position
	projectile.velocity = Vector2(300, 0).rotated($Weapon.rotation)
	projectile.rotation = $Weapon.rotation
	get_parent().add_child(projectile)
	#projectile.connect("treffer", self, "send_treffer")
	#projectile.look_at(get_global_mouse_position())
	$FireRateTimer.start()
	yield(get_tree().create_timer(longevity), "timeout")
	if is_instance_valid(projectile):
		projectile.queue_free()
		
func screenshake():
	print("Hi")

#func send_treffer(value, pposition):
	#emit_signal("getroffen", value, pposition)


func _on_HitInvunerable_timeout():
	only_once = true
	state = states.IDLE
	#set_deferred("collision_layer", 1)
	set_deferred("collision_mask", 1)
	$CollisionShape2D.set_deferred("disabled", false)
	$HitEffect.play("idle")

func pickup_passive_item(type_value):
	var type = type_value
	match type:
		"speed":
			speed = 350
			yield(get_tree().create_timer(12), "timeout")
			speed = 180

func spawn_dust() -> void:
	var dust: Sprite = DUST_SCENE.instance()
	dust.position = dust_position.global_position
	parent.add_child_below_node(parent.get_child(get_index() - 1), dust)


