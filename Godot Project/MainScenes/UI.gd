extends CanvasLayer

onready var inventoryContainer = $InventoryContainer

func _ready():
	inventoryContainer.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("open_inventory"):
		inventoryContainer.visible = !inventoryContainer.visible
