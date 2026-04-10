extends Node2D

const START_LEVEL: String = "res://Levels/tutorial_room_1.tscn"

@export var music: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $CanvasLayer/Cutscene/AudioStreamPlayer

func _ready() -> void:
	get_tree().paused = true
	AudioManager.play_music(music)
	PlayerManager.player.visible = false
	PlayerHUD.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	LevelManager.level_load_started.connect(_on_animation_player_animation_finished)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	PlayerManager.player.visible = true
	PlayerHUD.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)

func play_audio(_a: AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
