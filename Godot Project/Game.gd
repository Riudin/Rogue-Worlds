extends Node2D


onready var exitPortal = find_node("ExitPortal")
onready var playerChest = find_node("PlayerChest")

var chest_open = false


func _ready():
	Events.connect("chest_closed", self, "_on_chest_closed")

func _process(delta):
	if Input.is_action_just_released("ui_up"):
		if exitPortal.is_interactable():
			Transition.transition("res://MainScenes/Main.tscn")
			#queue_free()
		elif playerChest.is_interactable():
			if not chest_open:
				Events.emit_signal("chest_opened")
				chest_open = true
			else:
				Events.emit_signal("chest_closed")
				chest_open = false

func _on_chest_closed():
	chest_open = false
