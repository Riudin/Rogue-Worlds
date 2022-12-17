extends Panel


onready var ui = find_parent("UI")

var ItemClass = preload("res://Items/Item.tscn")
var item = null
var slot_index

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	WEAPON,
	SHIELD,
	HELMET,
	ARMOR,
	RING
}

var slotType = null


func pickFromSlot():
	remove_child(item)
	ui.add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	ui.remove_child(item)
	add_child(item)

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)


