extends Control
class_name HeartGUI

@onready var sprite: Sprite2D = $Sprite2D

var max_value_amount
var min_value_amount

var value: int = 2:
	set( _value):
		value = _value
		update_sprite()

func update_sprite() -> void:
	sprite.frame = value
