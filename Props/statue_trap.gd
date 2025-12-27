extends Node2D
class_name StatueTrap

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_trigger_area_2d_body_entered(body: Node2D) -> void:
	if body == PlayerManager.player:
		animation_player.play("triggered")
