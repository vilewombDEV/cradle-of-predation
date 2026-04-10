extends PlayerState
class_name PlayerStateDeath

@export var death_audio: AudioStream

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("death")
	player.audio_player.stream = death_audio
	player.audio_player.play()
	PlayerHUD.show_game_over_screen()
	AudioManager.play_music(null)

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	player.velocity.y = 0
	return null
