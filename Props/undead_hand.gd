extends Node2D
class_name UndeadHand

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_trigger_area_2d_body_entered(body: Node2D) -> void:
	if body == PlayerManager.player:
		animated_sprite_2d.play("triggered")
