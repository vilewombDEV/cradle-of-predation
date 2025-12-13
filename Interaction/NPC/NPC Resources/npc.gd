extends CharacterBody2D
class_name NPC

@export var npc_resource: NPCResource: set = _set_npc_resource


func _ready() -> void:
	gather_interactables()
	pass

func _set_npc_resource(_npc: NPCResource) -> void:
	npc_resource = _npc

func gather_interactables() -> void:
	for c in get_children():
		if c is DialogInteraction:
			c.player_interacted.connect(on_player_interacted)
			c.finished.connect(om_interaction_finished)

func on_player_interacted() -> void:
	pass

func om_interaction_finished() -> void:
	pass
