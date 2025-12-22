extends PlayerState
class_name PlayerStatePsychic

const PSYCHIC = preload("res://Player/Abilities/psychic.tscn")

var direction: Vector2 = Vector2.ZERO

@onready var ability_marker: Marker2D = %AbilityMarker2D


func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("psychic")
	player.animation_player.animation_finished.connect(_animation_finished)
	direction = player.axis_direction
	
	var _p: Psychic = PSYCHIC.instantiate()
	player.add_sibling(_p)
	_p.global_position = ability_marker.global_position
	var shoot_direction = player.direction
	if shoot_direction == Vector2.ZERO:
		shoot_direction = player.axis_direction
	_p.shoot(shoot_direction)

func exit() -> void:
	player.animation_player.animation_finished.disconnect(_animation_finished)
	next_state = null

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state 

func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state

func _animation_finished(_a: String) -> void:
	next_state = idle
