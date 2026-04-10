extends Control

@onready var popup: Window = $Window


func _ready() -> void:
	get_tree().paused = true
	popup.show()


func _on_window_close_requested() -> void:
	popup.hide()
	get_tree().paused = false
