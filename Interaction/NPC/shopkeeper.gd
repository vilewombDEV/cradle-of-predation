extends Node2D
class_name Shopkeeper

@export var shop_inventory: Array[ItemData]

@onready var dialog_branch_yes: DialogBranch = $Gypsy/DialogInteraction/DialogChoice/DialogBranch


func _ready() -> void:
	dialog_branch_yes.selected.connect(show_shop_menu)


func show_shop_menu() -> void:
	print("Show the menu")
