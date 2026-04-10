@tool
extends Node2D
class_name PatrolLocation

@export var wait_time: float = 0.0:
	set(v):
		wait_time = v
		_update_wait_time_label()

var target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	target_pos = global_position
	_update_wait_time_label()
	if Engine.is_editor_hint():
		return
	$Sprite2D.queue_free()

func update_label(_s: String) -> void:
	$Sprite2D/Label.text = _s

func update_line(next_location: Vector2) -> void:
	var line: Line2D = $Sprite2D/Line2D
	line.points[1] = next_location - position

func _update_wait_time_label() -> void:
	if Engine.is_editor_hint():
		$Sprite2D/Label2.text = "wait: " + str( snappedf(wait_time, 0.1) ) + "s"
