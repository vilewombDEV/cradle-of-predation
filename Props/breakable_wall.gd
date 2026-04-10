extends Node2D
class_name BreakableWall

#region /// On-Ready Variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var damaged_area: DamagedArea = $DamagedArea
@onready var is_torn_down_data: PersistentDataHandler = $IsTornDown
#endregion

var is_torn_down: bool = false

func _ready() -> void:
	damaged_area.damage_taken.connect(_on_damage_taken)
	is_torn_down_data.data_loaded.connect(set_wall_state)
	set_wall_state()

func set_wall_state() -> void:
	is_torn_down = is_torn_down_data.value
	if is_torn_down:
		sprite.hide()
	else:
		sprite.show()

func _on_damage_taken(attack_area: AttackArea) -> void:
	if is_torn_down:
		return
	if !is_torn_down:
		sprite.show()
		is_torn_down_data.set_value()
		is_torn_down = true
		queue_free()
	else:
		sprite.hide()
