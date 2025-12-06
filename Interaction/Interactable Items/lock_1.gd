extends Node2D
class_name AnimatedLock1

var is_open: bool = false

@export var key_item: ItemData
@export var locked_audio: AudioStream
@export var open_audio: AudioStream

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var is_open_data: PersistentDataHandler = $PersistentDataHandler
@onready var interact_area: Area2D = $InteractArea2D

func _ready() -> void:
	interact_area.area_entered.connect(_on_area_enter)
	interact_area.area_exited.connect(_on_area_exit)
	is_open_data.data_loaded.connect(set_state)
	set_state()

func set_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("Opened")
	else:
		animation_player.play("Closed")

func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(open_lock)

func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(open_lock)

func open_lock() -> void:
	if key_item == null:
		return
	var door_unlocked = PlayerManager.INVENTORY_DATA.use_item(key_item)
	
	if door_unlocked:
		animation_player.play("Opened")
		audio.stream = open_audio
		is_open_data.set_value()
	else:
		audio.stream = locked_audio
	audio.play()
