extends Area2D


export(Resource) var itemResource

onready var sprite = $Sprite

func _ready():
	sprite.texture = itemResource.texture

func _on_GroundItem_body_entered(body):
	if body == GameManager.player:
		GameManager.player.inventory.add_item(itemResource.name, 1)
		queue_free()
