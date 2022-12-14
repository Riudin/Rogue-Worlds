extends TextureRect

export(NodePath) onready var item_container = get_node(item_container) as Control

var item: Item


func _ready():
	pass

func set_item(new_item):
	item = new_item
