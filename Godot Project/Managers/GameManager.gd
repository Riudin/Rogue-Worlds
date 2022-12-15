extends Node

signal player_initialized

var player

func _process(delta):
	if not player:
		initialize_player()
		return

# this makes the player accessable from anywhere
func initialize_player():
	player = get_tree().get_root().get_node_or_null("/root/World/Player")
	if not player:
		return
	
	emit_signal("player_initialized", player)
	
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
	# loading a saved inventory if it exists and setting the new player inventory (that was made
	# when the player entered the scene tree) to it. we don't overwrite the saved inventory at this point
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		player.inventory.set_items(existing_inventory.get_items())
	else:
		print("No inventory found, creating new one")
		#lets give the player 3 Blood
		#player.inventory.add_item("Blood", 1)

# save the player inventory to disk whenever we get a "inventory_changed" signal
# maybe we need tweaking later on of we have multiple inventorys
func _on_player_inventory_changed(inventory):
	ResourceSaver.save("user://inventory.tres", inventory)

