extends Area2D

var damage = 1

func _ready():
	pass


func _on_Hitbox_body_entered(target):
	if target.get_class() == "Player":
		target.apply_damage(damage)
