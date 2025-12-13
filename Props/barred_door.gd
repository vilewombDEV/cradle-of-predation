extends Node2D
class_name BarredDoor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass

func open_door() -> void:
	animation_player.play("open_door")
	audio_stream_player.play()

func close_door() -> void:
	animation_player.play("closed_door")
	audio_stream_player.play()
