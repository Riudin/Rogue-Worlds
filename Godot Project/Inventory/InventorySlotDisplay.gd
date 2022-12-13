extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if item.amount > 1:
			itemAmountLabel.text = str(item.amount)
		else:
			itemAmountLabel.text = ""
	else:
		itemTextureRect.texture = null    #load("res://Inventory/Assets/inventory_slot_a_bg.png")
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]

	# allow stacking
	if my_item is Item and my_item.name == data.item.name and data.item.amount + my_item.amount <= data.item.max_stack_size:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	# if target stack is full, nothing happens (items still get swapped, but the amount is swapped as well)
	elif my_item is Item and my_item.name == data.item.name and my_item.amount == my_item.max_stack_size:
		print("stack full2")
		var my_item_amount_old = my_item.amount
		my_item.amount = data.item.amount
		data.item.amount = my_item_amount_old
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
		inventory.emit_signal("items_changed", [my_item_index])
	# allow filling up stacks
	elif my_item is Item and my_item.name == data.item.name and data.item.amount < data.item.max_stack_size:
		var transferable_amount = my_item.max_stack_size - my_item.amount
		my_item.amount -= transferable_amount
		data.item.amount += transferable_amount
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
#	print(my_item.amount, my_item.max_stack_size)
#	print(data.item.amount, data.item.max_stack_size)




