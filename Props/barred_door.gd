extends Node2D
class_name BarredDoor

var is_open: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var is_open_data: PersistentDataHandler = $IsOpen

func _ready() -> void:
	is_open_data.data_loaded.connect(set_state)
	set_state()

func open_door() -> void:
	animation_player.play("open_door")
	audio_stream_player.play()
	is_open_data.set_value()

func close_door() -> void:
	animation_player.play("closed_door")
	audio_stream_player.play()

func set_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
