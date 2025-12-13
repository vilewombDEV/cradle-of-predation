extends Node2D
class_name PressurePlate

signal activated
signal deactivated

var bodies: int = 0
var is_active: bool = false

@onready var area_2d: Area2D = $Area2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_activate: AudioStream = preload("res://Music & SFX/SFX/lever-01.wav")
@onready var audio_deactivate: AudioStream = preload("res://Music & SFX/SFX/lever-02.wav")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)

func _on_body_entered(b: Node2D) -> void:
	bodies += 1
	check_is_activated()

func _on_body_exited(b: Node2D) -> void:
	bodies -= 1
	check_is_activated()

func check_is_activated() -> void:
	if bodies > 0 and is_active == false:
		is_active = true
		animated_sprite.play("stepped_on")
		play_audio(audio_activate)
		activated.emit()
	elif bodies <= 0 and is_active == true:
		is_active = false
		animated_sprite.play("moving")
		play_audio(audio_deactivate)
		deactivated.emit()

func play_audio(_stream: AudioStream) -> void:
	audio.stream = _stream
	audio.play()
