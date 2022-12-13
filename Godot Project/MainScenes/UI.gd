extends CanvasLayer

onready var inventoryContainer = $InventoryContainer

func _ready():
	inventoryContainer.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("open_inventory"):
		if inventoryContainer.visible == true:
			inventoryContainer.visible = false
			Events.emit_signal("inventory_changed", false)
		else:
			inventoryContainer.visible = true
			Events.emit_signal("inventory_changed", true)
