extends DungeonRoom

const ITEMS: Array = [preload("res://Items/Kaffe.tscn"), preload("res://Items/MensaEssen.tscn"), preload("res://Items/PapasKreditkarte.tscn"), preload("res://Items/Textmarker.tscn"), preload("res://Items/MensaTablett.tscn")]

onready var item_pos: Position2D = get_node("ItemPos")


func _ready() -> void:
	var item: Node2D = ITEMS[randi() % ITEMS.size()].instance()
	item.position = item_pos.position
	add_child(item)

