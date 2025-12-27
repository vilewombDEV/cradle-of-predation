extends Node2D
class_name BeamAttack

@export var use_timer: bool = false
@export var time_between_attacks: float = 3.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if use_timer == true:
		attack_delay()

func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
	if use_timer == true:
		attack_delay()

func attack_delay() -> void:
	await get_tree().create_timer(time_between_attacks).timeout
	attack()
