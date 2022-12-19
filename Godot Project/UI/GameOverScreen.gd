extends Control



func _on_Button_pressed():
	Transition.transition("res://MainScenes/Menu.tscn")
	queue_free()
