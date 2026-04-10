@tool
extends CharacterBody2D
class_name NPC

signal do_behavior_enabled

var state: String = "idle"
var direction: Vector2 = Vector2.DOWN
var direction_name: String = "down"
var do_behavior: bool = true

@export var npc_resource: NPCResource: set = _set_npc_resource

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	do_behavior_enabled.emit()
	gather_interactables()

func _physics_process(delta: float) -> void:
	move_and_slide()

func update_animation() -> void:
	animation.play(state + "_" + direction_name)

func update_direction(target_pos: Vector2) -> void:
	direction = global_position.direction_to(target_pos)
	update_direction_name()
	if direction_name == "side" and direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func update_direction_name() -> void:
	var threshold: float = 0.45
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif direction.x > threshold || direction.x < -threshold:
		direction_name = "side"

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
