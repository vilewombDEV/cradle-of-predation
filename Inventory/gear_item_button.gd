extends Button

@export_multiline var description: String = ""

func _ready() -> void:
	mouse_entered.connect(_on_focus_entered)
	mouse_exited.connect(item_unfocused)

func _on_focus_entered() -> void:
	PauseMenu.update_item_description(description)

func item_unfocused() -> void:
	PauseMenu.update_item_description("")
