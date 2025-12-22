extends Node2D
class_name Fireball

@export var move_speed: float = 200.0
@export var fireball_audio: AudioStream

var move_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D
@onready var explode_sprite: Sprite2D = $ExplodeSprite
@onready var fireball_hurt_box: HurtBox = %FireballHurtBox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fireball_hurt_box.did_damage.connect(_on_did_damage)
	if fireball_audio:
		audio.stream = fireball_audio
		audio.play()

func _process(delta: float) -> void:
	position += move_direction * move_speed * delta

func shoot(shoot_dir: Vector2) -> void:
	move_direction = shoot_dir
	rotate_nodes()

func rotate_nodes() -> void:
	var angle: float = move_direction.angle()
	sprite.rotation = angle
	explode_sprite.rotation = angle 
	fireball_hurt_box.rotation = angle

func _on_did_damage() -> void:
	animation_player.play("fireball_explode")
	await animation_player.animation_finished
	queue_free()
