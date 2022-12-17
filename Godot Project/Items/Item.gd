extends Node2D


func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://Items/Assets/BloodItemSmall.png")
	else:
		$TextureRect.texture = load("res://Items/Assets/EyeItemSmall.png")
