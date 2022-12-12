extends Area2D

var player = null


func player_in_attack_range():
	return player != null


func _on_AttackRange_body_entered(body):
	if body.is_in_group("Player"):
		player = body


func _on_AttackRange_body_exited(body):
	if body.is_in_group("Player"):
		player = null
