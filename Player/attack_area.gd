extends Area2D
class_name AttackArea

@export var damage: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_area_entered)
	visible = false
	monitorable = false
	monitoring = false

func _area_entered(a: Area2D) -> void:
	if a is DamagedArea:
		a.take_damage(self)

func _on_body_entered(body: Node2D) -> void:
	if body is DamagedArea:
		body.take_damage(self) 

func activate(duration: float = 0.1) -> void:
	set_active()
	await get_tree().create_timer(duration).timeout
	set_active(false)

func set_active(value: bool = true) -> void:
	monitoring = value
	visible = value

func flip(direction_x: float) -> void:
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
