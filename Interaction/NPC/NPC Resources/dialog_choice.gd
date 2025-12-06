extends DialogItem
class_name DialogChoice

var dialog_branches: Array[DialogBranch]

func _ready() -> void:
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append(c)

func _get_configuration_warnings() -> PackedStringArray:
	if check_for_dialog_items() == false:
		return ["Requires at least 2 DialogBranch nodes."]
	else:
		return []
	pass

func check_for_dialog_items() -> bool:
	var _count: int = 0
	for c in get_children():
		if c is DialogBranch:
			_count += 1
			if _count > 1:
				return true
	return false
