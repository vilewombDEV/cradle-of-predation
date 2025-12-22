extends Node2D
class_name BloodVortex

enum State {INACTIVE, THROW, RETURN }

var player: Player
var direction: Vector2
var speed: float = 0
var state

@export var acceleration: float = 500.0
@export var max_speed: float = 400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blood_audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player

func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
	elif state == State.RETURN:
		direction = global_position.direction_to(player.global_position)
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to(player.global_position) <= 10:
			queue_free()

func throw(throw_direction: Vector2) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	animation_player.play("blood_vortex")
	blood_audio.play()
	visible = true
