extends DialogItem
class_name DialogBranch

signal selected

@export var text: String = "Ok..."

var dialog_items: Array[DialogItem]

func _ready() -> void:
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)
