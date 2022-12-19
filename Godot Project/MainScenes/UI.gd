extends CanvasLayer

var holding_item = null
var inventory_open = false

const gameOverScreen = preload("res://UI/GameOverScreen.tscn")

onready var playerInventory = $PlayerInventory
onready var chestInventory = $ChestInventory
onready var playerHotbar = $PlayerHotbar
onready var playerStatBars = $playerStatBars


func _ready():
	Events.connect("player_died", self, "_on_player_death")

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		playerInventory.visible = !playerInventory.visible
		playerInventory.initialize_inventory()
		if not inventory_open:
			Events.emit_signal("inventory_opened", true)
			playerHotbar.global_position.y = lerp(playerHotbar.global_position.y, playerHotbar.global_position.y + 16, 1)
			playerStatBars.global_position.y = lerp(playerStatBars.global_position.y, playerStatBars.global_position.y + 16, 1)
		else:
			Events.emit_signal("inventory_opened", false)
			playerHotbar.global_position.y = lerp(playerHotbar.global_position.y, playerHotbar.global_position.y - 16, 1)
			playerStatBars.global_position.y = lerp(playerStatBars.global_position.y, playerStatBars.global_position.y - 16, 1)
		inventory_open = !inventory_open
	
	if Input.is_action_just_pressed("chest_inventory"):
		chestInventory.visible = !chestInventory.visible
		chestInventory.initialize_inventory()
		if not inventory_open:
			Events.emit_signal("inventory_opened", true)
		else:
			Events.emit_signal("inventory_opened", false)
		inventory_open = !inventory_open
	

func _on_player_death():
	var game_over_screen = gameOverScreen.instance()
	add_child(game_over_screen)
