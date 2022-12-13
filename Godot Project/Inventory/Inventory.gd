extends Resource
class_name Inventory

signal items_changed(indexes)

var drag_data = null

export(Array, Resource) var items = [
	null, null, null, null, null, null,
	null, null, null, null, null, null,
	null, null, null, null, null, null,
	null, null, null, null, null, null,
	null, null, null, null, null, null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

# we need to duplicate each item at some point to make it unique.
# otherwise resources will be shared an things like stacking won't work.
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
