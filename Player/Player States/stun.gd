extends PlayerState
class_name PlayerStateStun

@export var invulnerable_duration: float = 3.0
@export var move_speed = 50
@onready var damaged_area: DamagedArea = %DamagedArea
@onready var attack_area: AttackArea = %AttackArea

var direction: float = 1.0
var time: float = 0.0

func init() -> void:
	damaged_area.damage_taken.connect(_player_damaged)

func enter() -> void:
	player.animation_player.play("stun")
	time = player.animation_player.current_animation_length
	damaged_area.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	PlayerManager.shake_camera(attack_area.damage)
	player.animation_player.animation_finished.connect(_animation_finished)
	player.update_direction()

func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	time -= _delta
	if time <= 0:
		if player.hp <= 0:
			return death
		return idle
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = move_speed * direction
	return null

func _player_damaged(attack_area: AttackArea) -> void:
	if player.current_state == death:
		return
	player.change_state(self)
	if attack_area.global_position.x < player.global_position.x:
		direction = 1.0
	else:
		direction = -1.0

func _animation_finished(_a: String) -> void:
	next_state = idle
