extends Node2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	animation_player.play("Pickup")

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().max_hp += 2
		area.get_parent().hp += 2
