extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body == PlayerManager.player:
		get_tree().reload_current_scene()
