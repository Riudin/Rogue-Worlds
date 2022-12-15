extends Node

var items = Array()

func _ready():
	# scan the ItemResources directory for all item resources
	var directory = Directory.new()
	directory.open("res://Items/ItemResources")
	directory.list_dir_begin()
	
	# load all files in the items array - we check here if the file is a directory and if it's not, 
	# we assume it's a *.tres file
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			items.append(load("res://Items/ItemResources/%s" % filename))
		
		filename = directory.get_next()

# this is for other scrips that want to use an item. this function gives them the corresponding 
# *.tres file from the items array
func  get_item(item_name):
	for i in items:
		if i.name == item_name:
			return i
	
	return null
