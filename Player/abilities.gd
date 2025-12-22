extends Node2D
class_name PlayerAbilities

const BLOOD_VORTEX = preload("res://Player/Abilities/blood_vortex.tscn")

@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var fireball: PlayerStateFireball = %Fireball
@onready var psychic: PlayerStatePsychic = %Psychic


var abilities: Array[String] = [
	"", "", "" # 1.) BLOOD_VORTEX, 2.) FIREBALL, 3.) PSYCHIC
	]

var selected_ability: int = 0

var player: Player

var blood_vortex_instance: BloodVortex = null

@onready var ability_marker: Marker2D = %AbilityMarker2D


func _ready() -> void:
	player = PlayerManager.player
	setup_abilities()
	SaveManager.game_loaded.connect(_on_game_loaded)
	PlayerManager.INVENTORY_DATA.ability_acquired.connect(_on_ability_acquired)

func setup_abilities(select_index: int = 0) -> void:
	PauseMenu.update_ability_items(abilities)
	PlayerHUD.update_ability_items(abilities)
	selected_ability = select_index - 1
	toggle_ability()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spell_ability"):
		match selected_ability:
			0:
				blood_vortex_ability()
			1:
				fireball_ability()
			2:
				psychic_ability()
	elif event.is_action_pressed("toggle_ability_ui"):
		toggle_ability()

func toggle_ability() -> void:
	if abilities.count("") == abilities.size():
		return
	selected_ability = wrapi(selected_ability + 1, 0, 3)
	while abilities[selected_ability] == "":
		selected_ability = wrapi(selected_ability + 1, 0, 3)
	PlayerHUD.update_ability_ui(selected_ability)

func blood_vortex_ability() -> void:
	if blood_vortex_instance != null:
		return
	var _b = BLOOD_VORTEX.instantiate() as BloodVortex
	player.add_sibling(_b)
	_b.global_position = ability_marker.global_position
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.axis_direction
	_b.throw(throw_direction)
	blood_vortex_instance = _b

func fireball_ability() -> void:
	if player.current_state == idle or player.current_state == run:
		player.change_state(fireball)

func psychic_ability() -> void:
	if player.current_state == idle or player.current_state == run:
		player.change_state(psychic)

func _on_game_loaded() -> void:
	var new_abilities = SaveManager.current_save.abilities
	abilities.clear()
	for a in new_abilities:
		abilities.append(a)
	setup_abilities()

func _on_ability_acquired(_ability: AbilityItemData) -> void:
	# 1.) BLOOD_VORTEX, 2.) FIREBALL, 3.) PSYCHIC
	match _ability.type:
		_ability.Type.BLOOD_VORTEX:
			abilities[0] = "BLOOD_VORTEX"
		_ability.Type.FIREBALL:
			abilities[1] = "FIREBALL"
		_ability.Type.PSYCHIC:
			abilities[2] = "PSYCHIC"
	setup_abilities(selected_ability)
