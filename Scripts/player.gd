extends NPC
class_name Player

signal player_damaged(hurt_box: HurtBox)
signal direction_changed(new_direction: Vector2)

#region /// On-Ready Variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hurt_box: HurtBox = %HurtBox
@onready var hit_box: HitBox = %HitBox
@onready var audio_player: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
@onready var player_abilities: PlayerAbilities = $Abilities

#endregion

#region /// Export Variables
@export var move_speed: float = 120.0
@export var max_fall_velocity: float = 400.0
@export var inventory: InventoryData = preload("res://Inventory/player_inventory.tres")
#endregion

#region /// State Machine Variables
var states: Array[PlayerState]
var current_state: PlayerState: 
	get: return states.front()
var previous_state: PlayerState:
	get: return states[1]
#endregion

#region /// Standard Variables
var direction: Vector2 = Vector2.ZERO
var axis_direction: Vector2 = Vector2.RIGHT
var gravity: float = 980
var gravity_multiplier: float = 1.0
var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6
var level: int = 1
var xp: int = 0
var attack: int = 1: 
	set(v):
		attack = v
		update_damage_values()
var defense: int = 1
var defense_bonus: int = 0

var insight: int = 1: ####### MAY DELETE IF DOESNT WORK
	set(iv): ####### MAY DELETE IF DOESNT WORK
		insight = iv ####### MAY DELETE IF DOESNT WORK
		update_insight_values() ####### MAY DELETE IF DOESNT WORK
var attunement: int = 1 ####### MAY DELETE IF DOESNT WORK
var attunement_bonus: int = 0 ####### MAY DELETE IF DOESNT WORK

#endregion

func _ready() -> void:
	PlayerManager.player = self
	initialize_states()
	hit_box.damaged.connect(_take_damage)
	update_hp(99)
	update_damage_values()
	update_insight_values() ####### MAY DELETE IF DOESNT WORK
	PlayerManager.player_leveled_up.connect(_on_player_leveled_up)
	PlayerManager.INVENTORY_DATA.equipment_changed.connect(_on_equipment_changed)

func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	move_and_slide()
	change_state(current_state.physics_process(_delta))

func initialize_states() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
	if states.size() == 0:
		return
	for state in states:
		state.init()
	change_state(current_state)
	current_state.enter()

func change_state(new_state: PlayerState) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	if current_state:
		current_state.exit()
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)

func update_direction() -> void:
	var prev_direction: Vector2 = direction
	
	var x_axis = Input.get_axis("move_left", "move_right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
	direction_changed.emit(direction)

func set_direction() -> bool:
	var new_dir: Vector2 = axis_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	return true

func _unhandled_key_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	if event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()

func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable == true:
		return
	if hp > 0:
		var dmg: int = hurt_box.damage
		if dmg > 0:
			dmg = clampi(dmg - defense - defense_bonus, 1, dmg)
		update_hp(-dmg)
		player_damaged.emit(hurt_box)

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHUD.update_hp(hp, max_hp)

func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true

func revive_player() -> void:
	print("Player: ", hp)
	update_hp(99)
	change_state(%Idle)

func update_damage_values() -> void:
	var damage_value: int = attack + PlayerManager.INVENTORY_DATA.get_attack_bonus()
	%HurtBox.damage = damage_value

func update_insight_values() -> void: ####### MAY DELETE IF DOESNT WORK
	var ability_value: int = insight + PlayerManager.INVENTORY_DATA.get_insight_bonus() ####### MAY DELETE IF DOESNT WORK

func _on_player_leveled_up() -> void:
	effect_animation_player.play("level_up")
	update_hp(max_hp)

func _on_equipment_changed() -> void:
	update_damage_values()
	update_insight_values() ####### MAY DELETE IF DOESNT WORK
	defense_bonus = PlayerManager.INVENTORY_DATA.get_defense_bonus()
