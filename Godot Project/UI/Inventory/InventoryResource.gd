extends Resource
class_name InventoryResource


export(String) var inventory_name
export(Dictionary) var inventory = {
	#0: ["BloodItemSmall", 20],  
	#--> slot_index: [item_name, item_quantity]
}

export(Dictionary) var hotbar = {}
export(Dictionary) var equips = {}
