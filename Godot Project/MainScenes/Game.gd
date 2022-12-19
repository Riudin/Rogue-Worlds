extends Node2D


onready var exitPortal = find_node("ExitPortal")


func _process(delta):
	if exitPortal.is_interactable():
		if Input.is_action_just_released("ui_up"):
			
			Transition.transition("res://MainScenes/Main.tscn")
			#queue_free()
