extends Character
class_name Enemy

var path: PoolVector2Array

onready var navigation: Navigation2D = get_tree().current_scene.get_node("Rooms")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = get_node("PathTimer")
var player_visible = true

func _process(delta):
	if player_visible == false:
		mov_direction = Vector2.ZERO
		velocity = Vector2.ZERO
		#$AnimationPlayer.play("idle")
		#if  $AnimationPlayer.current_animation != "idle":
			#$AnimationPlayer.stop()
	#else:
	#	$AnimationPlayer.play()

	
		
func _ready() -> void:
	var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")
	player.connect("invisible", self, "on_player_hidden")
	player.connect("visible", self, "on_player_revealed")

#func _physics_process(delta):
	#signal mit dem Raum verbinden, im Raum idle Funktion von Kindern aufrufen
	#if player_visible == false:
	#	velocity = Vector2.ZERO
	#	move_and_slide(velocity)
	
func chase() -> void:
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 3:
			path.remove(0)
			if not path:
				return
		mov_direction = vector_to_next_point


func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO
		
		
func _get_path_to_player() -> void:
	path = navigation.get_simple_path(global_position, player.position)

func on_player_hidden():
	print("IT")
	player_visible = false
	#$FiniteStateMachine._add_state("idle")
	#$FiniteStateMachine.set_state($FiniteStateMachine.states.idle)

func on_player_revealed():
	player_visible = true
	take_damage(1, Vector2.ZERO, 1)
	
