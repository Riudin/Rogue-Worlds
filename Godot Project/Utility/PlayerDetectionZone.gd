extends Area2D

var player = null


func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body# Replace with function body.

func _on_PlayerDetectionZone_body_exited(body):
	if body.is_in_group("Player"):
		player = null
