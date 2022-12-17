extends Node2D

var item_name
var item_quantity

func _ready():
	var rand_val = randi() % 2
	if rand_val == 0:
		item_name = "BloodItemSmall"
	else:
		item_name = "EyeItemSmall"
	
	$TextureRect.texture = load("res://Items/Assets/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1 or item_quantity == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://Items/Assets/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

func halve_item_quantity():
	item_quantity = item_quantity / 2
	$Label.text = String(item_quantity)
