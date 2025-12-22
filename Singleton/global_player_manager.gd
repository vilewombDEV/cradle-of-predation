extends Node

signal interact_pressed
signal player_leveled_up

const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA: InventoryData = preload("res://Inventory/player_inventory.tres")

var player: Player
var player_spawned: bool = false

var level_requirements = [0, 100, 200, 400, 800, 1000, 1500, 2000, 2500, 3000, 5000]

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos

func set_as_parent(_p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)

func unparent_player(_p: Node2D) -> void:
	_p.remove_child(player)

func set_health(_hp: int, _max_hp: int) -> void:
	player.max_hp = _max_hp
	player.hp = _hp
	player.update_hp(0)

func reward_xp(_xp: int) -> void:
	player.xp += _xp
	check_for_level_advance()

func check_for_level_advance() -> void:
	if player.level >= level_requirements.size():
		return
	if player.xp >= level_requirements[player.level]:
		player.level += 1
		player.attack += 2
		player.defense += 2
		player.insight += 2 ####### MAY DELETE IF DOESNT WORK
		player.attunement += 2 ####### MAY DELETE IF DOESNT WORK
		player_leveled_up.emit()
		check_for_level_advance()
