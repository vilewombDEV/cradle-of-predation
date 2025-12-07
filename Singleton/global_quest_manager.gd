extends Node

signal quest_updated( q )

const QUEST_DATA_LOCATION: String = "res://Quests/Quest/"

var quests: Array[Quest]
var current_quests: Array = []

func _ready() -> void:
	gather_quest_data()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		print( "get_quest_index_by_title: ", get_quest_index_by_title("Recover Lost Skull") )
		print( "get_quest_index_by_title: ", get_quest_index_by_title("Short Quest") )

func gather_quest_data() -> void:
	# Gather all Quest resources and add to the Quests Array
	var quest_files: PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	for q in quest_files:
		quests.append( load( QUEST_DATA_LOCATION + "/" + q ) as Quest )
		print( "Quests Count: ", quests.size() )
	pass

func update_quest(_title: String, _completed_step: String = "", _is_complete: bool = false) -> void:
	var quest_index: int = get_quest_index_by_title(_title)
	if quest_index == -1:
		var new_quest: Dictionary = {
			title = _title,
			_is_complete = _completed_step,
			completed_steps = []
		}
		if _completed_step != "":
			new_quest.completed_steps.append(_completed_step)
			current_quests.append(new_quest)
			quest_updated.emit(new_quest)
	else:
		var q = current_quests[quest_index]
		if _completed_step != "" and q.completed_steps.has(_completed_step) == false:
			q.completed_steps.append(_completed_step)
		q.is_complete = _is_complete
		quest_updated.emit(q)
		if q.is_complete == true:
			disperse_quest_rewards(find_quest_by_title(_title))

func disperse_quest_rewards(_q: Quest) -> void:
	PlayerManager.reward_xp(_q.reward_xp)
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item(i.item, i.quantity)

func find_quest(_quest: Quest) -> Dictionary:
	for q in current_quests:
		if q.title == _quest.title:
			return q
	return { title = "Not Found", is_complete = false, completed_steps = [''] }

func find_quest_by_title(_title: String) -> Quest:
	for q in quests:
		if q.title == _title:
			return q
	return null

func get_quest_index_by_title(_title: String) -> int:
	for i in current_quests.size():
		if current_quests[i].title == _title:
			return i
	return -1

func sort_quests() -> void:
	pass
