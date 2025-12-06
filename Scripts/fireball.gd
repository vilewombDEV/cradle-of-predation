extends Node2D
class_name Fireball

@export var move_speed = 185
@export var fireball_sfx: AudioStream

@onready var hurt_box: HurtBox = $HurtBox
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	hurt_box.did_damage.connect(_on_did_damage)
	if fireball_sfx:
		audio_stream_player.stream = fireball_sfx
		audio_stream_player.play()

func _process(delta: float) -> void:
	position += (Vector2.RIGHT * move_speed).rotated(rotation) * delta


func _on_did_damage() -> void:
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
