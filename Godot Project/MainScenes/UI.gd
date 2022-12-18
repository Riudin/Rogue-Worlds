extends CanvasLayer

var holding_item = null
var inventory_open = false

onready var playerInventory = $PlayerInventory
onready var chestInventory = $ChestInventory

func _input(event):
	if event.is_action_pressed("inventory"):
		playerInventory.visible = !playerInventory.visible
		playerInventory.initialize_inventory()
		if not inventory_open:
			Events.emit_signal("inventory_opened", true)
		else:
			Events.emit_signal("inventory_opened", false)
		inventory_open = !inventory_open
	
	if event.is_action_pressed("chest_inventory"):
		chestInventory.visible = !chestInventory.visible
		chestInventory.initialize_inventory()
		if not inventory_open:
			Events.emit_signal("inventory_opened", true)
		else:
			Events.emit_signal("inventory_opened", false)
		inventory_open = !inventory_open
