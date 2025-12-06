extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body == PlayerManager.player:
		PlayerManager.player.update_hp(-99)
