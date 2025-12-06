extends Area2D
class_name DialogInteraction

signal player_interacted
signal finished

@export var enabled: bool = true

var dialog_items: Array[DialogItem]

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)

func player_interact() -> void:
	player_interacted.emit()
	DialogSystem.show_dialog(dialog_items)
	DialogSystem.finished.connect(on_dialog_finished)

func on_dialog_finished() -> void:
	DialogSystem.finished.disconnect(on_dialog_finished)
	finished.emit()

func _on_area_entered(_area: Area2D) -> void:
	if enabled == false || dialog_items.size() == 0:
		return
	animation.play("Show")
	PlayerManager.interact_pressed.connect(player_interact)


func _on_area_exited(_area: Area2D) -> void:
	animation.play("Hide")
	PlayerManager.interact_pressed.disconnect(player_interact)

func _get_configuration_warnings() -> PackedStringArray:
	if check_for_dialog_items() == false:
		return ["Requires at least one DialogItem node."]
	else:
		return []
	pass

func check_for_dialog_items() -> bool:
	for c in get_children():
		if c is DialogItem:
			return true
	return false
