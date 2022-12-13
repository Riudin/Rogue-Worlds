extends GridContainer

var inventory = preload("res://Inventory/Inventory.tres")

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	Events.connect("item_picked_up", self, "_on_item_picked_up")
	inventory.make_items_unique()
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _on_item_picked_up(item_resource):
	#check if you already have the item
	for item in inventory.items:
		if item and item.name == item_resource.name:
			#check if you can stack the item
			if item.amount < item.max_stack_size:
				item.amount += 1
				update_inventory_display()
				Events.emit_signal("item_pick_up_successful", item_resource)
				return
	#if not, check for empty slot
	if inventory.items.has(null):
		var empty_slot = inventory.items.find(null)
		inventory.set_item(empty_slot, item_resource)
		Events.emit_signal("item_pick_up_successful", item_resource)
	else:
		print("No inventory space")


func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
