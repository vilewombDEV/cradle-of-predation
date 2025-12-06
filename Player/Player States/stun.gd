extends PlayerState
class_name PlayerStateStun

@export var knockback_speed: float = 100.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var direction: Vector2

func init() -> void:
	player.player_damaged.connect(_player_damaged)

func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	direction = player.global_position.direction_to(player.hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.update_direction()
	player.animation_player.play("stun")
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")

func exit() -> void:
	player.animation_player.animation_finished.disconnect(_animation_finished)

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state 

func process(_delta: float) -> PlayerState:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state

func _player_damaged(_hurt_box: HurtBox) -> void:
	player.hurt_box = _hurt_box
	if player.current_state != death:
		player.change_state(self)

func _animation_finished(_a: String) -> void:
	next_state = idle
	if player.hp <= 0:
		next_state = death
