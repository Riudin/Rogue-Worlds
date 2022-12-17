extends Panel

var ItemClass = preload("res://Items/Item.tscn")
var item = null

func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instance()
		add_child(item)


func pick_from_slot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
