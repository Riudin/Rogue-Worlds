extends TextureRect
class_name SlotClass


export(Resource) var itemResource = null

onready var itemTexture = $CenterContainer/ItemTexture
#onready var groundItem = preload("res://Items/GroundItem.tscn")

var player

func _ready():
	GameManager.connect("player_initialized", self, "_on_player_initialized")
	put_into_slot(load("res://Items/ItemResources/Eye.tres"))

func _on_player_initialized(p):
	player = p

func _process(delta):
	if itemResource:
		itemTexture.texture = itemResource.texture
	else:
		itemTexture.texture = null

func pick_from_slot():
	itemResource = null

func put_into_slot(new_item):
	itemResource = new_item
	#itemResource.position = Vector2.ZERO
	var slotContainerNode = find_parent("SlotContainer")
	slotContainerNode.remove_child(itemResource)
	$CenterContainer.add_child(itemResource)
	#$CenterContainer/groundItem.itemResource = itemResource
	player.inventory.add_item(new_item.name, new_item.quantity)


