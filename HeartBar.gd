extends HBoxContainer

var heart_full = preload("res://Art/Neu/heartfull.png")
var heart_half = preload("res://Art/Neu/hearthalf.png")
#var heart_empty = preload("res://icon.png")

enum TYPES {type1, type2}
export (TYPES) var type = TYPES.type1

func update_bar(value):
	match type:
		TYPES.type1:
			update_type1(value)
		TYPES.type2:
			update_type2(value)

func update_type1(value):
	for i in self.get_child_count():
		if i  < value:
			get_child(i).show()
			get_child(i).get_child(0).play("fine")
			#get_child(i).get_child(0).stop()
			#get_child(i).get_child(0).seek(0, true)
		else:
			#get_child(i).hide()
			get_child(i).get_child(0).play("hurt")

func update_type2(value):
	for i in self.get_child_count():
		if i == int(value) && (value - int(value) != 0):
			get_child(i).show()
			get_child(i).texture = heart_half
		elif i < value:
			get_child(i).show()
			get_child(i).texture = heart_full
		else:
			get_child(i).hide()
