extends Node2D
class_name PlayerInteractionsHost

@onready var player: Player = PlayerManager.player

func _ready() -> void:
	player.direction_changed.connect(update_direction)

func update_direction(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.LEFT:
			rotation_degrees = -45
		Vector2.RIGHT:
			rotation_degrees = 45
