extends CanvasLayer

#region /// Constants
const OPEN_SHOP = preload("res://Music & SFX/SFX/open__shop.wav")
const PURCHASE = preload("res://Music & SFX/SFX/079_Buy_sell_01.wav")
const ERROR = preload("res://Music & SFX/SFX/033_Denied_03.wav")
const SHOP_ITEM_BUTTON = preload("res://Inventory/ShopGUI/shop_item_button.tscn")
const MENU_SELECT = preload("res://Music & SFX/SFX/select.mp3")
const MENU_FOCUS = preload("res://Music & SFX/SFX/hover.mp3")
#endregion

var currency_eyeball: ItemData = preload("res://Inventory/Items/eyeballs.tres")

signal shown
signal hidden

var is_active: bool = false

#region /// On-Ready Variables
@onready var close_button: Button = %CloseButton
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer
@onready var eyes_label: Label = %EyesLabel
@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_price: Label = %ItemPrice
@onready var item_held_count: Label = %ItemHeldCount
@onready var insufficient_eyes: AnimationPlayer = $Control/PlayerCurrency/InsufficientEyes
#endregion


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()
	close_button.pressed.connect(hide_menu)

func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if event.is_action_pressed("pause_game"):
		get_viewport().set_input_as_handled()
		hide_menu()

func show_menu(items: Array[ItemData], dialog_triggered: bool = true) -> void:
	if dialog_triggered:
		await DialogSystem.finished
	enable_menu()
	populate_item_list(items)
	update_currency()
	shop_items_container.get_child(0).grab_focus()
	play_audio(OPEN_SHOP)
	shown.emit()

func hide_menu() -> void:
	enable_menu(false)
	clear_item_list()
	hidden.emit()

func enable_menu(_enabled: bool = true) -> void:
	get_tree().paused = _enabled
	visible = _enabled
	is_active = _enabled

func update_currency() -> void:
	eyes_label.text = str(get_item_quantity(currency_eyeball))

func get_item_quantity(item: ItemData) -> int:
	return PlayerManager.INVENTORY_DATA.get_item_held_quantity(item)

func clear_item_list() -> void:
	for c in shop_items_container.get_children():
		c.queue_free()

func populate_item_list(items: Array[ItemData]) -> void:
	for item in items:
		var shop_item: ShopItemButton = SHOP_ITEM_BUTTON.instantiate()
		shop_item.setup_item(item)
		shop_items_container.add_child(shop_item)
		shop_item.focus_entered.connect(update_item_details.bind(item))
		shop_item.pressed.connect(_purchase_item.bind(item))

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()

func focused_item_changed(item: ItemData) -> void:
	play_audio(MENU_FOCUS)
	if item:
		update_item_details(item)

func update_item_details(item: ItemData) -> void:
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_price.text = str(item.cost)
	item_held_count.text = str(get_item_quantity(item))

func _purchase_item(item: ItemData) -> void:
	var can_purchase: bool = get_item_quantity(currency_eyeball) >= item.cost
	if can_purchase:
		play_audio(PURCHASE)
		var inv: InventoryData = PlayerManager.INVENTORY_DATA
		inv.add_item(item)
		inv.use_item(currency_eyeball, item.cost)
		update_currency()
		update_item_details(item)
	else:
		play_audio(ERROR)
		insufficient_eyes.play("insufficient_eyes")
		insufficient_eyes.seek(0)
