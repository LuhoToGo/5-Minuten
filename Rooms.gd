extends Navigation2D

const STAGE1_SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"), preload("res://Rooms/SpawnRoom1.tscn"), preload("res://Rooms/SpawnRoom2.tscn")]
const STAGE1_INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room0.tscn"), preload("res://Rooms/Room1.tscn"), preload("res://Rooms/Room2.tscn"), preload("res://Rooms/Room3.tscn"), preload("res://Rooms/Room4.tscn"), preload("res://Rooms/Room5.tscn"), preload("res://Rooms/Room6.tscn"), preload("res://Rooms/Room7.tscn"), preload("res://Rooms/Room8.tscn"), preload("res://Rooms/Room9.tscn"), preload("res://Rooms/Room10.tscn"), preload("res://Rooms/Room11.tscn"), preload("res://Rooms/Room12.tscn"), preload("res://Rooms/Room13.tscn"), preload("res://Rooms/SpecialRoom0.tscn"), preload("res://Rooms/SpecialRoom1.tscn"), preload("res://Rooms/SpecialRoom2.tscn")]
const STAGE1_END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]
const STAGE2_SPAWN_ROOMS: Array = [preload("res://Rooms/Stage2_SpawnRoom0.tscn"), preload("res://Rooms/Stage2_SpawnRoom1.tscn"), preload("res://Rooms/Stage2_SpawnRoom2.tscn")]
const STAGE2_INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Stage2_Room0.tscn"), preload("res://Rooms/Stage2_Room1.tscn"), preload("res://Rooms/Stage2_Room2.tscn"), preload("res://Rooms/Stage2_Room3.tscn"), preload("res://Rooms/Stage2_Room4.tscn"), preload("res://Rooms/Stage2_Room5.tscn"), preload("res://Rooms/Stage2_Room6.tscn"), preload("res://Rooms/Stage2_Room7.tscn"), preload("res://Rooms/Stage2_Room8.tscn"), preload("res://Rooms/Stage2_Room9.tscn"), preload("res://Rooms/Stage2_Room10.tscn"), preload("res://Rooms/Stage2_Room11.tscn"), preload("res://Rooms/Stage2_Room12.tscn"), preload("res://Rooms/Stage2_Room13.tscn"), preload("res://Rooms/Stage2_SpecialRoom0.tscn"), preload("res://Rooms/Stage2_SpecialRoom1.tscn"), preload("res://Rooms/Stage2_SpecialRoom2.tscn")]
const STAGE2_END_ROOMS: Array = [preload("res://Rooms/Stage2_EndRoom0.tscn")]
const STAGE3_SPAWN_ROOMS: Array = [preload("res://Rooms/Stage3_SpawnRoom0.tscn"), preload("res://Rooms/Stage3_SpawnRoom1.tscn"), preload("res://Rooms/Stage3_SpawnRoom2.tscn")]
const STAGE3_INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Stage3_Room0.tscn"), preload("res://Rooms/Stage3_Room1.tscn"), preload("res://Rooms/Stage3_Room2.tscn"), preload("res://Rooms/Stage3_Room3.tscn"), preload("res://Rooms/Stage3_Room4.tscn"), preload("res://Rooms/Stage3_Room5.tscn"), preload("res://Rooms/Stage3_Room6.tscn"), preload("res://Rooms/Stage3_Room7.tscn"), preload("res://Rooms/Stage3_Room8.tscn"), preload("res://Rooms/Stage3_Room9.tscn"), preload("res://Rooms/Stage3_Room10.tscn"), preload("res://Rooms/Stage3_Room11.tscn"), preload("res://Rooms/Stage3_Room12.tscn"), preload("res://Rooms/Stage3_Room13.tscn"), preload("res://Rooms/Stage3_SpecialRoom0.tscn"), preload("res://Rooms/Stage3_SpecialRoom1.tscn"), preload("res://Rooms/Stage3_SpecialRoom2.tscn")]
const STAGE3_END_ROOMS: Array = [preload("res://Rooms/Stage3_EndRoom0.tscn")]
const FINAL_SCENE: PackedScene = preload("res://Rooms/Final.tscn")

const TILE_SIZE: int = 16
const STAGE1_FLOOR_TILE_INDEX: int = 41
const STAGE2_FLOOR_TILE_INDEX: int = 68
const STAGE3_FLOOR_TILE_INDEX: int = 105
const RIGHT_WALL_TILE_INDEX: int = 43
const LEFT_WALL_TILE_INDEX: int = 46

export(int) var num_levels: int = 6

var final = false

onready var player: KinematicBody2D = get_parent().get_node("Player")


func _ready() -> void:
	SavedData.num_floor += 1
	_spawn_rooms()
	
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false
	if SavedData.num_floor == 4:
		num_levels = 1
	
	for i in num_levels:
		var room: Node2D
		
		if SavedData.num_floor == 1:
			if i == 0:
				room = STAGE1_SPAWN_ROOMS[randi() % STAGE1_SPAWN_ROOMS.size()].instance()
				player.position = room.get_node("PlayerSpawnPos").position
			else:
				if i == num_levels - 1:
					room = STAGE1_END_ROOMS[randi() % STAGE1_END_ROOMS.size()].instance()	
				else:
					room = STAGE1_INTERMEDIATE_ROOMS[randi() % STAGE1_INTERMEDIATE_ROOMS.size()].instance()
				
				var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
				var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
				var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
				var corridor_height: int = randi() % 5 + 2
				for y in corridor_height:
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), STAGE1_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), STAGE1_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
					
				var room_tilemap: TileMap = room.get_node("TileMap")
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
		elif SavedData.num_floor == 2:
			if i == 0:
				room = STAGE2_SPAWN_ROOMS[randi() % STAGE2_SPAWN_ROOMS.size()].instance()
				player.position = room.get_node("PlayerSpawnPos").position
			else:
				if i == num_levels - 1:
					room = STAGE2_END_ROOMS[randi() % STAGE2_END_ROOMS.size()].instance()
				else:
					room = STAGE2_INTERMEDIATE_ROOMS[randi() % STAGE2_INTERMEDIATE_ROOMS.size()].instance()
				
				var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
				var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
				var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
				var corridor_height: int = randi() % 5 + 2
				for y in corridor_height:
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), STAGE2_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), STAGE2_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
					
				var room_tilemap: TileMap = room.get_node("TileMap")
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
		elif SavedData.num_floor == 3:
			if i == 0:
				room = STAGE3_SPAWN_ROOMS[randi() % STAGE3_SPAWN_ROOMS.size()].instance()
				player.position = room.get_node("PlayerSpawnPos").position
			else:
				if i == num_levels - 1:
					room = STAGE3_END_ROOMS[randi() % STAGE3_END_ROOMS.size()].instance()
				else:
					room = STAGE3_INTERMEDIATE_ROOMS[randi() % STAGE3_INTERMEDIATE_ROOMS.size()].instance()
				
				var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
				var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
				var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
				var corridor_height: int = randi() % 5 + 2
				for y in corridor_height:
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), STAGE3_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), STAGE3_FLOOR_TILE_INDEX)
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
					
				var room_tilemap: TileMap = room.get_node("TileMap")
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
		elif SavedData.num_floor == 4:
				room = FINAL_SCENE.instance()
				player.position = room.get_node("PlayerSpawnPos").position
		add_child(room)
		previous_room = room
		
		
