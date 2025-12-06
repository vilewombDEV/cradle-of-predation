extends Node2D
class_name PlayerSpawn


func _ready() -> void:
	visible = false
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position(global_position)
		PlayerManager.player_spawned = true
