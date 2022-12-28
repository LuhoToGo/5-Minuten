extends Node

var num_floor: int = 0

var hp: int = 4
var weapons: Array = []
var equipped_weapon_index: int = 0
var ms = 0
var s = 0
var m = 6

func reset_data() -> void:
	num_floor = 0
	
	hp = 4
	weapons = []
	equipped_weapon_index = 0
	
	#timer reset
	ms = 0
	s = 0
	m = 6

