extends Control
class_name SplashScreen

signal finished

func _ready() -> void:
	$"VileDEV Logo/AnimationPlayer".animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_name: String) -> void:
	finished.emit()
