@tool
extends Node2D
class_name ItemDropper

const PICKUP = preload("res://Inventory/item_pickup.tscn")

var has_dropped: bool = false

@export var item_data: ItemData: set = _set_item_data

@onready var sprite: Sprite2D = $Sprite2D
@onready var has_dropped_data: PersistentDataHandler = $PersistentDataHandler
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if Engine.is_editor_hint()== true:
		_update_texture()
		return
	sprite.visible = false
	has_dropped_data.data_loaded.connect(_on_data_loaded)
	_on_data_loaded()

func drop_item() -> void:
	if has_dropped == true:
		return
	has_dropped = true
	
	var drop = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data
	add_child(drop)
	drop.picked_up.connect(_on_drop_picked_up)
	audio.play()

func _on_drop_picked_up() -> void:
	has_dropped_data.set_value()

func _on_data_loaded() -> void:
	has_dropped = has_dropped_data.value

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _update_texture() -> void:
	if Engine.is_editor_hint() == true:
		if item_data and sprite:
			sprite.texture = item_data.texture
