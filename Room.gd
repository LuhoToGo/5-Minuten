extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"Enemy": preload("res://Enemy.tscn")
}

var num_enemies: int

onready var tilemap: TileMap = get_node("Navigation2D/TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	
func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		print("hier koennte ihre Belohnung stehen")

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position), 1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position) + Vector2.UP, 2)
		
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children(): 
		var enemy: KinematicBody2D = ENEMY_SCENES.Enemy.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.global_position = enemy_position.global_position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_explosion)


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()
