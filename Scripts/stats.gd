extends PanelContainer
class_name Stats

var inventory: InventoryData

@onready var label_level: Label = %Label_Level
@onready var label_xp: Label = %Label_XP
@onready var label_attack: Label = %Label_Attack
@onready var label_defense: Label = %Label_Defense
@onready var label_attack_change: Label = %Label_Attack_Change
@onready var label_defense_change: Label = %Label_Defense_Change

####### MAY DELETE IF DOESNT WORK
@onready var label_insight: Label = %Label_Insight
@onready var label_insight_change: Label = %Label_Insight_Change
@onready var label_attunement: Label = %Label_Attunement
@onready var label_attunement_change: Label = %Label_Attunement_Change
####### MAY DELETE IF DOESNT WORK


func _ready() -> void:
	PauseMenu.shown.connect(update_stats)
	PauseMenu.preview_stats_changed.connect(_on_preview_stats_changed)
	inventory = PlayerManager.INVENTORY_DATA
	inventory.equipment_changed.connect(update_stats)

func update_stats() -> void:
	var _p: Player = PlayerManager.player
	label_level.text = str(_p.level)
	if _p.level < PlayerManager.level_requirements.size():
		label_xp.text = str(_p.xp) + "/" + str(PlayerManager.level_requirements[_p.level])
	else:
		label_xp.text = "MAX LEVEL"
	label_attack.text = str(_p.attack + inventory.get_attack_bonus())
	label_defense.text = str(_p.defense + inventory.get_defense_bonus())
	
	####### MAY DELETE IF DOESNT WORK
	label_insight.text = str(_p.insight + inventory.get_insight_bonus())
	label_attunement.text = str(_p.attunement + inventory.get_attunement_bonus())
	####### MAY DELETE IF DOESNT WORK

func _on_preview_stats_changed(item: ItemData) -> void:
	label_attack_change.text = ""
	label_defense_change.text = ""
	
	####### MAY DELETE IF DOESNT WORK
	label_insight_change.text = ""
	label_attunement_change.text = ""
	####### MAY DELETE IF DOESNT WORK
	
	if not item is EquipableItemData:
		return
	
	var equipment: EquipableItemData = item
	var attack_delta: int = inventory.get_attack_bonus_diff(equipment)
	var defense_delta: int = inventory.get_defense_bonus_diff(equipment)
	
	####### MAY DELETE IF DOESNT WORK
	var insight_delta: int = inventory.get_insight_bonus_diff(equipment)
	var attunement_delta: int = inventory.get_attunement_bonus_diff(equipment)
	####### MAY DELETE IF DOESNT WORK
	
	update_change_label(label_attack_change, attack_delta)
	update_change_label(label_defense_change, defense_delta)
	
	####### MAY DELETE IF DOESNT WORK
	update_change_label(label_insight_change, insight_delta)
	update_change_label(label_attack_change, attunement_delta)
	####### MAY DELETE IF DOESNT WORK
	

func update_change_label(label: Label, value: int) -> void:
	if value > 0:
		label.text = "+" + str(value)
		label.modulate = Color.LIGHT_GREEN
	elif value < 0:
		label.text = str(value)
		label.modulate = Color.INDIAN_RED
