extends Area2D


func _on_BloodItem_body_entered(body):
	if body == GameManager.player:
		GameManager.player.inventory.add_item("Blood", 1)
		queue_free()
