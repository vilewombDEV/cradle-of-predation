extends PlayerState
class_name PlayerStateAttack

@export var attack_sound: AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

func init() -> void:
	pass

func enter() -> void:
	do_attack()
	player.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	next_state = null

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state 

func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	return null

func do_attack() -> void:
	player.animation_player.play("attack")
	player.attack_area.activate()
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()

func _end_attack() -> void:
	if player.is_on_floor():
		next_state = idle
	else:
		next_state = fall

func _on_animation_finished(_anim_name: String) -> void:
	_end_attack()
