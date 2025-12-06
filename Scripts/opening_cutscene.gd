extends Control

var next_scene = preload("res://Levels/tutorial.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(next_scene)
