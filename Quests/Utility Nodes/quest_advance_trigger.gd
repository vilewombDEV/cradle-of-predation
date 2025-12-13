@tool
@icon("res://Quests/Utility Nodes/quest_advance.png")
extends QuestNode
class_name QuestAdvanceTrigger

@export_category("Parent Signal Connection")
@export var signal_name: String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	$Sprite2D.queue_free()
	if signal_name != "":
		if get_parent().has_signal(signal_name):
			get_parent().connect(signal_name, advance_quest)
	
func advance_quest() -> void:
	if linked_quest == null:
		return
	var _title: String = linked_quest.title
	var _step: String = get_step()
	if _step == "N/A":
		_step = ""
	print("Advance_Quest: " + _title)
	QuestManager.update_quest(_title, _step, quest_complete)
