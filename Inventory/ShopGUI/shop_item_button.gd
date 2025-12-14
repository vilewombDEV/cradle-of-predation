extends Button
class_name ShopItemButton

var item: ItemData

func setup_item(_item: ItemData) -> void:
	item = _item
	$Label.text = item.name
	$PriceLabel.text = str(item.cost)
	$TextureRect.texture = item.texture
