extends DungeonRoom


const BOSS: PackedScene = preload("res://Characters/Enemies/ProfessorLang/ProfessorLang.tscn")
onready var boss_pos = Vector2(245, 124)


func _ready() -> void:
	var boss: Node2D = BOSS.instance()
	boss.global_position = boss_pos
	add_child(boss)
	pass

