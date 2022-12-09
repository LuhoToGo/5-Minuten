extends Enemy

const PROJECTILE_SCENE: PackedScene = preload("res://Characters/Enemies/Shooting Enemy/Projectile.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40

export(int) var projectile_speed: int = 150

var can_attack: bool = true

var distance_to_player: float

onready var attack_timer: Timer = get_node("AttackTimer")
onready var aim_raycast: RayCast2D = get_node("AimRayCast")

func _process(_delta: float) -> void:
	if player.global_position > self.global_position:
		$AnimatedSprite.flip_h = true
		$CollisionShape2D2.set_deferred("disabled", false)
		$CollisionShape2D.disabled = true
	else:
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.set_deferred("disabled", false)
		$CollisionShape2D2.disabled = true

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			aim_raycast.cast_to = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
				can_attack = false
				_shoot()
				attack_timer.start()
	else:
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO
			
			
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(global_position, global_position + dir * 100)
	
	
func _shoot() -> void:
	var projectile: Area2D = PROJECTILE_SCENE.instance()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)



func _on_AttackTimer_timeout() -> void:
	can_attack = true
