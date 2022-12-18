extends Node2D

const SlotClass = preload("res://Inventory/Slot.gd")
const ItemDrop = preload("res://Items/ItemDrop.tscn")
onready var inventory_slots = $InventorySlots
onready var equip_slots = $EquipmentSlots.get_children()
onready var ui = find_parent("UI")

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slotType = SlotClass.SlotType.WEAPON
	equip_slots[1].slotType = SlotClass.SlotType.SHIELD
	equip_slots[2].slotType = SlotClass.SlotType.HELMET
	equip_slots[3].slotType = SlotClass.SlotType.ARMOR
	equip_slots[4].slotType = SlotClass.SlotType.RING
	equip_slots[5].slotType = SlotClass.SlotType.RING
	
	initialize_inventory()
	initialize_equips()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if ui.holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if ui.holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
		if event.button_index == BUTTON_RIGHT && event.pressed:
			# holding an item
			if ui.holding_item != null:
				# clicking empty slot
				if !slot.item:
					right_click_empty_slot(slot)
				# clicking slot with item
				else:
					# item is different
					if ui.holding_item.item_name != slot.item.item_name:
						right_click_different_item(event, slot)
					#item is the same
					else:
						right_click_same_item(slot)
			# not holding an item but clicking on one
			elif slot.item:
				right_click_not_holding(slot)

func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed:
		if ui.holding_item != null:
			var new_item_drop = ItemDrop.instance()
			new_item_drop.item_name = ui.holding_item.item_name
			#new_item_drop.itemTexture.texture = ui.holding_item.itemTexture.texture
			new_item_drop.item_quantity = ui.holding_item.item_quantity
			new_item_drop.position = get_tree().get_root().get_node("Main").get_local_mouse_position() -Vector2(8, 8)
			get_tree().get_root().get_node("Main").add_child(new_item_drop)
#			PlayerInventory.remove_item(slot)
			ui.holding_item.queue_free()
			ui.holding_item = null

# warning-ignore:unused_argument
func _input(event):
	if ui.holding_item:
		ui.holding_item.global_position = get_global_mouse_position() - Vector2(8, 8)
		
		
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = ui.holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == SlotClass.SlotType.WEAPON:
		return holding_item_category == "Weapon"
	elif slot.slotType == SlotClass.SlotType.SHIELD:
		return holding_item_category == "Shield"
	elif slot.slotType == SlotClass.SlotType.HELMET:
		return holding_item_category == "Helmet"
	elif slot.slotType == SlotClass.SlotType.ARMOR:
		return holding_item_category == "Armor"
	elif slot.slotType == SlotClass.SlotType.RING:
		return holding_item_category == "Ring"
	return true

###
### Left click functions
###

func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(ui.holding_item, slot)
		slot.putIntoSlot(ui.holding_item)
		ui.holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(ui.holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position - Vector2(8, 8)
		slot.putIntoSlot(ui.holding_item)
		ui.holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= ui.holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, ui.holding_item.item_quantity)
			slot.item.add_item_quantity(ui.holding_item.item_quantity)
			ui.holding_item.queue_free()
			ui.holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			ui.holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	ui.holding_item = slot.item
	slot.pickFromSlot()
	ui.holding_item.global_position = get_global_mouse_position() - Vector2(8, 8)

###
### Right click functions
###

# put just 1 in slot
func right_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(ui.holding_item, slot)
		slot.initialize_item(ui.holding_item.item_name, 1)
		ui.holding_item.decrease_item_quantity(1)
		if ui.holding_item.item_quantity < 1:
			ui.holding_item.queue_free()
			ui.holding_item = null

# swap items
func right_click_different_item(event: InputEvent, slot: SlotClass):
	left_click_different_item(event, slot)

# put just 1 on stack
func right_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= ui.holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, 1)
			slot.item.add_item_quantity(1)
			ui.holding_item.decrease_item_quantity(1)
			if ui.holding_item.item_quantity < 1:
				ui.holding_item.queue_free()
				ui.holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, 1)
			slot.item.add_item_quantity(1)
			ui.holding_item.decrease_item_quantity(1)

# split stack in half
func right_click_not_holding(slot: SlotClass):
	var original_quantity = slot.item.item_quantity
	slot.item.halve_item_quantity()
	PlayerInventory.remove_item(slot)
	ui.holding_item = slot.item
	slot.pickFromSlot()
	ui.holding_item.global_position = get_global_mouse_position() - Vector2(8, 8)
	slot.initialize_item(ui.holding_item.item_name, ui.holding_item.item_quantity)
	if original_quantity % 2 == 1:
		ui.holding_item.add_item_quantity(1)
