extends Control



func _on_Button_pressed():
	Transition.transition("res://UI/Menu.tscn")
	queue_free()
