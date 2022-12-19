extends Node2D


onready var exitPortal = find_node("ExitPortal")
onready var playerChest = find_node("PlayerChest")


func _process(delta):
	if Input.is_action_just_released("ui_up"):
		if exitPortal.is_interactable():
			Transition.transition("res://MainScenes/Main.tscn")
			#queue_free()
		elif playerChest.is_interactable():
			Events.emit_signal("chest_opened")
	
	if not playerChest.is_interactable():
		Events.emit_signal("chest_closed")
