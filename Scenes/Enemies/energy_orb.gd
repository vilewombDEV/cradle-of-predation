extends Node2D
class_name EnergyOrb

@export var speed: float = 250.0
@export var shoot_audio: AudioStream
@export var hit_audio: AudioStream

var direction: Vector2 = Vector2.DOWN

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var damaged_area: DamagedArea = $DamagedArea
@onready var hazard_area: HazardArea = $HazardArea

func _ready() -> void:
	damaged_area.damage_taken.connect(_hit_player)
	play_audio(shoot_audio)
	get_tree().create_timer(5).timeout.connect(destroy)
	direction = global_position.direction_to(PlayerManager.player.global_position)
	flicker()

func _process(delta: float) -> void:
	position += direction * speed * delta

func flicker() -> void:
	modulate.a = randf() * 0.7 + 0.3
	await get_tree().create_timer(0.05).timeout
	flicker()

func _hit_player() -> void:
	play_audio(hit_audio)
	damaged_area.set_deferred("monitoring", false)

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()

func destroy() -> void:
	queue_free()
