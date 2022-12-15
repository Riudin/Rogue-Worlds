extends Control



func _on_PlayButton_pressed():
	Transition.transition("res://MainScenes/World.tscn")


func _on_SettingsButton_pressed():
	pass


func _on_QuitButton_pressed():
	get_tree().quit()
