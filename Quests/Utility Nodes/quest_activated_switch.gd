@tool
@icon("res://Quests/Utility Nodes/quest_switch.png")
extends QuestNode
class_name QuestActivatedSwitch

enum CheckType {HAS_QUEST, QUEST_STEP_COMPLETE, ON_CURRENT_QUEST_STEP, QUEST_COMPLETE}

signal is_activated_changed(v: bool)

@export var check_type: CheckType = CheckType.HAS_QUEST
@export var remove_when_activated: bool = false
