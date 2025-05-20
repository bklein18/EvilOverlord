extends Node

static func create_item(name: String, quantity: int, description: String, type: Items.Item.ItemTypes) -> Items.Item:
	var item = Items.Item.new()
	item.Name = name
	item.CurrentQuantity = quantity
	item.Description = description
	item.ItemType = type
	return item

class Item:
	var Name: String = ""
	var CurrentQuantity: int = 0
	var Description: String = ""
	var ItemType: ItemTypes = ItemTypes.Trash
	
	enum ItemTypes {
		Healing,
		Buff,
		Debuff,
		Sellable,
		Trash
	}
