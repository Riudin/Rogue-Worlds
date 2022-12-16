extends Resource
class_name Inventory

signal inventory_changed

export var _items = Array() setget set_items, get_items
export var name : String

# emit signal if you change _items
func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)

# getter for _items
func get_items():
	return _items

# returns the item from _items you are looking for
# not to be confused with get_items()
func get_item(index):
	return _items[index]

# adding an item to the inventory
func add_item(item_name, quantity):
	# is the amount we're trying to add positive?
	if quantity <= 0:
		print("Can't add a negative number of items")
		return
	
	# does the item we're trying to add exist?
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("Could not find item")
		return
	
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable  else  1
	
	# if it's a stackable item check if we already have a stack of it
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				break
			
			var inventory_item = _items[i]
			
			if inventory_item.item_reference.name != item.name:
				continue
			
			# if we have a stack check if the stack has room and add items accordingly
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	# if there's no more stacks in the inventory that have room, create a new one
	# loop to see if we need to make a full stack and continue or if we make a partial stack and are done
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity
	
	emit_signal("inventory_changed", self)
