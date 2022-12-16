extends GridContainer


var holding_item = null

onready var inventory_slots : Array = self.get_children()


func _ready():
	GameManager.connect("player_initialized", self, "_on_player_initialized")
	for inv_slot in inventory_slots:
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item:
					# place holding item into slot
					slot.put_into_slot(holding_item)
					holding_item = null
				else:
					# swap holding item with item in slot
					var temp_item = slot.item
					slot.pick_from_slot()
					temp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()


func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()







func _on_player_initialized(player):
	pass
#	player.inventory.connect("inventory_changed", self, "_on_inventory_changed")
#
#func _on_inventory_changed(inventory):
#	pass
#	for n in get_children():
#		n.queue_free()
#
#	for item in inventory.get_items():
#		var item_label = Label.new()
#		item_label.text = "%s x%d" % [item.item_reference.name, item.quantity]
#		add_child(item_label)
