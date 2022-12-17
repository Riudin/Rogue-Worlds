extends CanvasLayer

var holding_item = null
var inventory_open = false

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		if not inventory_open:
			Events.emit_signal("inventory_opened", true)
		else:
			Events.emit_signal("inventory_opened", false)
		inventory_open = !inventory_open
