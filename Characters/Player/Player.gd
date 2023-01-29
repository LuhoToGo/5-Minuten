extends Character

const DUST_SCENE: PackedScene = preload("res://Characters/Player/Dust.tscn")
const FLECK: PackedScene = preload("res://Items/Fleck.tscn")
const textmarker = preload("res://Art/Neu/Textmarker.png")
const kreditkarte = preload("res://Art/Neu/Papa‘s Creditcard.png")
const tablett = preload("res://Art/Neu/Tablett.png")

enum {UP, DOWN}
enum ACTIVE_ITEM {EMPTY, KREDITKARTE, TEXTMARKER, TABLETT}
var current_weapon: Node2D
var current_item = ACTIVE_ITEM.EMPTY
export (int) var speed = 200
var latest_dir = Vector2.UP

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)
signal invisible
signal visible
signal item_change
signal item_count
signal item_pickup

onready var parent: Node2D = get_parent()
onready var weapons: Node2D = get_node("Weapons")
onready var dust_position: Position2D = get_node("DustPosition")
onready var dash_uses = 2


func _ready() -> void:
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	_restore_previous_state()
	
func _restore_previous_state() -> void:
	self.hp = SavedData.hp
	self.max_speed = SavedData.speed
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
		weapon.hide()
		
		emit_signal("weapon_picked_up", weapon.get_texture())
		emit_signal("weapon_switched", weapons.get_child_count() - 2, weapons.get_child_count() - 1)
	current_weapon = weapons.get_child(SavedData.equipped_weapon_index)
	current_weapon.show()
	emit_signal("weapon_switched", weapons.get_child_count() - 1, SavedData.equipped_weapon_index)
	
	if SavedData.item == 0:
		pass
	elif SavedData.item == 1:
		current_item = ACTIVE_ITEM.TABLETT
		item_change(tablett)
	elif SavedData.item == 2:
		item_change(kreditkarte)
	elif SavedData.item == 3:
		current_item = ACTIVE_ITEM.TEXTMARKER
		item_change(textmarker)

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x < 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
		$CollisionShape2D.set_deferred("disabled", false)
		$CollisionShape2D2.disabled = true
	elif mouse_direction.x > 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		$CollisionShape2D2.set_deferred("disabled", false)
		$CollisionShape2D.disabled = true
	current_weapon.move(mouse_direction)
		
		
func get_input() -> void:
	if $FiniteStateMachine.state != $FiniteStateMachine.states.dashing:
		mov_direction = Vector2.ZERO
		if Input.is_action_pressed("ui_down"):
			mov_direction += Vector2.DOWN
			latest_dir = Vector2.DOWN
		if Input.is_action_pressed("ui_left"):
			mov_direction += Vector2.LEFT
			latest_dir = Vector2.LEFT
		if Input.is_action_pressed("ui_right"):
			mov_direction += Vector2.RIGHT
			latest_dir = Vector2.RIGHT
		if Input.is_action_pressed("ui_up"):
			mov_direction += Vector2.UP
			latest_dir = Vector2.UP
		
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and current_weapon.get_index() != 0:
			_drop_weapon()
		
	current_weapon.get_input()
	if Input.is_action_just_pressed("ui_select"):
		use_active_item()
	
func _switch_weapon(direction: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
			
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	SavedData.equipped_weapon_index = index
	
	emit_signal("weapon_switched", prev_index, index)
	
	
func pick_up_weapon(weapon: Node2D) -> void:
	$WeaponPickUp.play()
	print(weapon.name)
	match weapon.name:
		"Beeer":
			item_pickup("One liner Bier")
		"BGB":
			item_pickup("One liner bgb")
	SavedData.weapons.append(weapon.duplicate())
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon
	
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)
	
	
func _drop_weapon() -> void:
	SavedData.weapons.remove(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	
	emit_signal("weapon_droped", weapon_to_drop.get_index())
	
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	yield(weapon_to_drop.tween, "tree_entered")
	weapon_to_drop.show()
	
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
		
		
func cancel_attack() -> void:
	current_weapon.cancel_attack()
	
	
func spawn_dust() -> void:
	var dust: Sprite = DUST_SCENE.instance()
	dust.position = dust_position.global_position
	parent.add_child_below_node(parent.get_child(get_index() - 1), dust)
		
		
func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false

func textmarker() -> void:
	var i = 0
	while i < 100:
		var drop_position = self.global_position
		yield(get_tree().create_timer(0.04), "timeout")
		if mov_direction != Vector2.ZERO:
			var fleck  = FLECK.instance()
			fleck.global_position = drop_position
			parent.add_child(fleck)
			i = i + 1
		yield(get_tree().create_timer(0.01), "timeout")

func use_active_item () -> void:
	match current_item:
		ACTIVE_ITEM.KREDITKARTE:
			self.set_collision_mask_bit(3, false)
			emit_signal("invisible")
			self.modulate.a = 0.5
			yield(get_tree().create_timer(10), "timeout")
			self.modulate.a = 1
			emit_signal("visible")
			current_item = ACTIVE_ITEM.EMPTY
		ACTIVE_ITEM.TEXTMARKER:
			textmarker()
			current_item = ACTIVE_ITEM.EMPTY
		ACTIVE_ITEM.TABLETT:
			var max_speed_before_dash = self.max_speed
			$FiniteStateMachine.set_state($FiniteStateMachine.states.dashing)
			mov_direction = latest_dir*10
			max_speed = 500
			speed = 500
			if dash_uses == 0:
				current_item = ACTIVE_ITEM.EMPTY
			match dash_uses:
				3:
					item_count("3")
				2:
					item_count("2")
				1:
					item_count("1")
				0:
					item_count(" ")
					current_item = ACTIVE_ITEM.EMPTY
			yield(get_tree().create_timer(0.2), "timeout")
			$FiniteStateMachine.set_state($FiniteStateMachine.states.move)
			max_speed = max_speed_before_dash
			speed = 200
			dash_uses -= 1
	if current_item == ACTIVE_ITEM.EMPTY:
		item_change(null)
		SavedData.item = 0

func item_change (texture) -> void:
	emit_signal("item_change", texture)
	
func item_pickup (label) -> void:
	emit_signal("item_pickup", label)

func item_count(number) -> void:
	emit_signal("item_count", number)
