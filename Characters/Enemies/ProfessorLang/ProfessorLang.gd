extends EnemyBoss

const PROJECTILE_SCENE: PackedScene = preload("res://Characters/Enemies/ProfessorLang/BossProjectile.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40

export(int) var projectile_speed: int = 100
var rng = RandomNumberGenerator.new()
var can_attack: bool = true
var can_move: bool = false
var is_shooting: bool = false
var state_randomm: bool = false
var a = 0
onready var spawnareas = [$Area2D/Node2D, $Area2D/Node2D2, $Area2D/Node2D3, $Area2D/Node2D4, $Area2D/Node2D5, $Area2D/Node2D6, $Area2D/Node2D7, $Area2D/Node2D8]
var distance_to_player: float
var functions = [1, 2, 3]
onready var spawnareas1 = [$Node2D, $Node2D2, $Node2D3, $Node2D4]
onready var attack_timer: Timer = get_node("AttackTimer")
onready var aim_raycast: RayCast2D = get_node("AimRayCast")
onready var ecke1 = get_parent().get_node("EckeLinks")
onready var ecke2 = get_parent().get_node("EckeRechts")
onready var mitte = get_parent().get_node("Mitte")
onready var destination  = mitte.position
onready var vonlinks  
onready var vonrechts 

func _ready():
	#$Area2D.rotation_degrees = rand_range(-180, 180)
	#yield(get_tree().create_timer(5), "timeout")
	randomize()
	randomstate(3)
	yield(get_tree().create_timer(1), "timeout")
	#_shootstrahl()
func _process(_delta: float) -> void: 
	if can_move == true:
		mov_direction = destination - self.position
	$Area2D.rotation_degrees += 0.3
	$BossHealth.value = hp
	#_shoot()
	pass
	
func randomstate(previousstate) -> void:
	#not previous state
	functions.erase(previousstate)
	var rand_value = functions[randi() % functions.size()]
	#print(rand_value)
	functions.append(previousstate)
	match rand_value:
		1:
			$AttackTimer.start()
		2:
			can_move = true
			is_shooting = true
			state_randomm = true
			max_speed = 195
			var rand_dest = randi() % 2
			if rand_dest == 0:
				destination = ecke1.position
				vonlinks  = ecke2.position
				vonrechts  = mitte.position
			if rand_dest == 1:
				destination = ecke2.position
				vonlinks  = mitte.position
				vonrechts  = ecke1.position
		3:
			waitstate()
		4:
			can_move = true
			$MovementStateTimer.start()
			$RandomMovementTimer.start()
	pass
	

func random_direction():
	var random_x = 0
	var random_y = 0
	rng.randomize()
	random_x = rng.randi_range(-50, 50)
	random_y = rng.randi_range(-50, 50)
	#$MovementTimer.wait_time = rng.randf_range(1, 2)
	destination = Vector2(random_x, random_y)
	$RandomMovementTimer.start()
	
func waitstate() -> void:
	yield(get_tree().create_timer(1.5), "timeout")
	randomstate(3)
	
func _shootstrahl() -> void:
	var i = 0
	while is_shooting:
		for spawnpoint in spawnareas1:
			var projectile: Area2D = PROJECTILE_SCENE.instance()
			projectile.position = spawnpoint.global_position
			projectile.direction = Vector2.DOWN
			projectile.projectile_speed = 185
			projectile.rotation_speed = 0
			projectile.should_rotate = false
			yield(get_tree().create_timer(0.03), "timeout")
			get_tree().root.add_child(projectile)
			i+= 1
		yield(get_tree().create_timer(0.04), "timeout")
	
func _shoot() -> void:
	for spawnpoint in spawnareas:
		var projectile: Area2D = PROJECTILE_SCENE.instance()
		projectile.position = spawnpoint.global_position
		projectile.direction = (projectile.position - self.global_position).normalized()
		#projectile.launch(spawnpoint.global_position, daren, projectile_speed)
	#projectile.launch(projectile.position, (self.position - global_position).normalized(), projectile_speed)
		get_tree().root.add_child(projectile)
		a += 1
	#PROJECTILE_SCENE.projectile_speed = 100
	
	
	#$Area2D/Area2D.add_child(projectile)



func _on_AttackTimer_timeout() -> void:
	can_move = false
	can_attack = true
	if a < 35:
		_shoot()
	elif a > 35:
		#_shootstrahl()
		$AttackTimer.stop()
		a = 0
		randomstate(1)


func _on_EckeLinks_body_entered(body):
	#mov_direction = ecke2.position - self.position
	destination = vonlinks
	if vonlinks == ecke2.position:
		_shootstrahl()


func _on_EckeRechts_body_entered(body):
	#mov_direction = mitte.position - self.position
	destination = vonrechts
	if vonrechts == ecke1.position:
		_shootstrahl()


func _on_Mitte_body_entered(body):
	if  is_shooting:
		mov_direction = Vector2.ZERO
		can_move = false
		is_shooting = false
		max_speed = 130
		randomstate(2)
		destination =  mitte.position
	#$FiniteStateMachine.set_state($FiniteStateMachine.states.idle)



func _on_MovementStateTimer_timeout():
	$RandomMovementTimer.stop()
	state_randomm = false
	randomstate(4)


func _on_RandomMovementTimer_timeout():
	random_direction()


func _on_Mitte_body_exited(body):
	can_move = true
