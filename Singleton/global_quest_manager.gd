extends Node

signal quest_updated( q )

const QUEST_DATA_LOCATION: String = "res://Quests/Quest/"

var quests: Array[Quest]
var current_quests: Array = []

func _ready() -> void:
	gather_quest_data()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		#print(find_quest_by_title("Find Gypsy"))
		#print("Current Quests: ", current_quests)
		#print("get_quest_index_by_title: ", get_quest_index_by_title("find gypsy"))
		#print("get_quest_index_by_title: ", get_quest_index_by_title("short quest"))
		
		#print("before: ", current_quests)
		#update_quest("short quest", "", true)
		#update_quest("find gypsy", "Search Main Hall")
		#update_quest("long quest", "", true)
		#print("after: ", current_quests)
		print("Quests: ", current_quests)
		#print("==============")
		pass

func gather_quest_data() -> void:
	# Gather all Quest resources and add to the Quests Array
	var quest_files: PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	for q in quest_files:
		quests.append( load( QUEST_DATA_LOCATION + "/" + q ) as Quest )
	print("Quest Count: ", quests.size())

func update_quest(_title: String, _completed_step: String = "", _is_complete: bool = false) -> void:
	var quest_index: int = get_quest_index_by_title(_title)
	if quest_index == -1:
		var new_quest: Dictionary = { 
				title = _title, 
				is_complete = _is_complete, 
				completed_steps = []
		}
		if _completed_step != "":
			new_quest.completed_steps.append(_completed_step)
		
		current_quests.append(new_quest)
		quest_updated.emit(new_quest)
		
		# Display a notification that quest was added
		
	else:
		var q = current_quests[quest_index]
		if _completed_step != "" and q.completed_steps.has(_completed_step) == false:
			q.completed_steps.append(_completed_step)
		q.is_complete = _is_complete
		quest_updated.emit(q)
		
		# Display a notification that quest was updated OR completed
		
		if q.is_complete == true:
			disperse_quest_rewards(find_quest_by_title(_title))

func disperse_quest_rewards(_q: Quest) -> void:
	PlayerManager.reward_xp(_q.reward_xp)
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item(i.item, i.quantity)

func find_quest(_quest: Quest) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return { title = "Not Found", is_complete = false, completed_steps = [''] }

func find_quest_by_title(_title: String) -> Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower():
			return q
	return null

func get_quest_index_by_title(_title: String) -> int:
	for i in current_quests.size():
		if current_quests[i].title.to_lower() == _title.to_lower():
			return i
	return -1

func sort_quests() -> void:
	var active_quests: Array = []
	var completed_quests: Array = []
	for q in current_quests:
		if q.is_complete:
			completed_quests.append(q)
		else:
			active_quests.append(q)
			
	active_quests.sort_custom(sort_quests_ascending)
	completed_quests.sort_custom(sort_quests_ascending)
	
	current_quests = active_quests
	current_quests.append_array(completed_quests)

func sort_quests_ascending(a, b):
	if a.title < b.title:
		return true
	return false
