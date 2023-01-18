extends Node2D
class_name DungeonRoom

export(bool) var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Characters/Enemies/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"S1_REGULAR_ENEMY": preload("res://Characters/Enemies/Regular Enemy/RegularEnemy.tscn"),
	"S1_SHOOTING_ENEMY": preload("res://Characters/Enemies/Shooting Enemy/ShootingEnemy.tscn"),
	"S1_PROJECTOR": preload("res://Characters/Enemies/Overheadprojektor/Overheadprojektor.tscn"),
	"S2_REGULAR_ENEMY": preload("res://Characters/Enemies/S2_Regular Enemy/RegularEnemy.tscn"),
	"S2_SHOOTING_ENEMY": preload("res://Characters/Enemies/S2_Shooting Enemy/ShootingEnemy.tscn"),
	"S2_PROJECTOR": preload("res://Characters/Enemies/S2_Overheadprojektor/Overheadprojektor.tscn"),
	"S3_REGULAR_ENEMY": preload("res://Characters/Enemies/S3_Regular Enemy/RegularEnemy.tscn"),
	"S3_SHOOTING_ENEMY": preload("res://Characters/Enemies/S3_Shooting Enemy/ShootingEnemy.tscn"),
	"S3_PROJECTOR": preload("res://Characters/Enemies/S3_Overheadprojektor/Overheadprojektor.tscn")
}

var num_enemies: int

onready var tilemap: TileMap = get_node("TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var player_visible = true


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	player.connect("invisible", self, "on_player_hidden")
	player.connect("visible", self, "on_player_revealed")
	
func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
	
	
func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		
		
func _close_entrance() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 44)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.DOWN, 42)
		
		
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D
		var random = randi() % 3
		if SavedData.num_floor == 1:
			if random == 0:
				enemy = ENEMY_SCENES.S1_REGULAR_ENEMY.instance()
			elif random == 1:
				enemy = ENEMY_SCENES.S1_SHOOTING_ENEMY.instance()
			elif random == 2:
				enemy = ENEMY_SCENES.S1_PROJECTOR.instance()
		elif SavedData.num_floor == 2:
			if random == 0:
				enemy = ENEMY_SCENES.S2_REGULAR_ENEMY.instance()
			elif random == 1:
				enemy = ENEMY_SCENES.S2_SHOOTING_ENEMY.instance()
			elif random == 2:
				enemy = ENEMY_SCENES.S2_PROJECTOR.instance()
		elif SavedData.num_floor == 3:
			if random == 0:
				enemy = ENEMY_SCENES.S3_REGULAR_ENEMY.instance()
			elif random == 1:
				enemy = ENEMY_SCENES.S3_SHOOTING_ENEMY.instance()
			elif random == 2:
				enemy = ENEMY_SCENES.S3_PROJECTOR.instance()
		enemy.position = enemy_position.position
		enemy.player_visible = player_visible
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)
		



func _on_PlayerDetector_body_entered(_body: KinematicBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()
		
func on_player_hidden():
	player_visible = false

func on_player_revealed():
	player_visible = true
