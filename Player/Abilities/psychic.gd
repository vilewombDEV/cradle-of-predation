extends Node2D
class_name Psychic

@export var move_speed: float = 200.0
@export var psychic_audio: AudioStream

var move_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D
@onready var psychic_hurt_box: HurtBox = %PsychicHurtBox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	psychic_hurt_box.did_damage.connect(_on_did_damage)
	if psychic_audio:
		audio.stream = psychic_audio
		audio.play()

func _process(delta: float) -> void:
	position += move_direction * move_speed * delta

func shoot(shoot_dir: Vector2) -> void:
	move_direction = shoot_dir
	rotate_nodes()

func rotate_nodes() -> void:
	var angle: float = move_direction.angle()
	sprite.rotation = angle
	psychic_hurt_box.rotation = angle

func _on_did_damage() -> void:
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
