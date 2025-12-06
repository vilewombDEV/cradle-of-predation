extends Node2D

const START_LEVEL: String = "res://Levels/cutscene.tscn"

@export var music: AudioStream
@export var button_focus: AudioStream
@export var button_pressed: AudioStream

@onready var new_game: Button = $"CanvasLayer/MainMenu/VBoxContainer/New Game"
@onready var load_game: Button = $"CanvasLayer/MainMenu/VBoxContainer/Load Game"
@onready var exit: Button = $CanvasLayer/MainMenu/VBoxContainer/Exit

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	PlayerHUD.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	if SaveManager.get_save_file() == null:
		load_game.disabled = true
		load_game.visible = false
	$CanvasLayer/SplashScene.finished.connect(setup_title_screen)
	LevelManager.level_load_started.connect(exit_title_screen)

func setup_title_screen() -> void:
	AudioManager.play_music(music)
	new_game.pressed.connect(start_game)
	load_game.pressed.connect(load_game_pressed)
	exit.pressed.connect(exit_button_pressed)
	new_game.grab_focus()
	new_game.focus_entered.connect(play_audio.bind(button_focus))
	load_game.focus_entered.connect(play_audio.bind(button_focus))
	exit.focus_entered.connect(play_audio.bind(button_focus))

func start_game() -> void:
	play_audio(button_pressed)
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)
	pass

func load_game_pressed() -> void:
	play_audio(button_pressed)
	SaveManager.load_game()

func exit_button_pressed() -> void:
	get_tree().quit()

func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHUD.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()

func play_audio(_a: AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()

func _on_new_game_mouse_entered() -> void:
	audio_stream_player.play()
func _on_load_game_mouse_entered() -> void:
	audio_stream_player.play()
func _on_exit_mouse_entered() -> void:
	audio_stream_player.play()
