extends Area2D

var interactable = false


func is_interactable():
	return interactable


func _on_ExitPortal_body_entered(body):
	if body.is_in_group("Player"):
		interactable = true

func _on_ExitPortal_body_exited(body):
	if body.is_in_group("Player"):
		interactable = false


func _on_PlayerChest_body_entered(body):
	if body.is_in_group("Player"):
		interactable = true

func _on_PlayerChest_body_exited(body):
	if body.is_in_group("Player"):
		interactable = false
		Events.emit_signal("chest_closed")
