extends GridContainer


export(String) var inventory_name
export(int) var size = 30  #maybe later setget to set different sizes

#export(NodePath) onready var title = get_node(title) as Label     #if we want titles for different inverntories
export(NodePath) onready var slot_container = get_node(slot_container) as Control

var slots: Array = []

func _ready():
	pass
