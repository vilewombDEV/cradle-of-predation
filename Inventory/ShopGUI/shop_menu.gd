extends CanvasLayer

signal shown
signal hidden

var is_active: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()
	pass

func show_menu(dialog_triggered: bool = true) -> void:
	if dialog_triggered:
		await DialogSystem.finished
	enable_menu()

func hide_menu() -> void:
	enable_menu(false)

func enable_menu(_enabled: bool = true) -> void:
	get_tree().paused = _enabled
	visible = _enabled
	is_active = _enabled
