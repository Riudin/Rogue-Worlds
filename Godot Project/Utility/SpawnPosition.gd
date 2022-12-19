extends Area2D

onready var collisionShape = $CollisionShape2D

var center_pos
var size

var random_position = Vector2.ZERO

func _ready():
	center_pos = collisionShape.position + self.position
	size = collisionShape.shape.extents * 2

func get_random_position():
	randomize()
	random_position.x = (randi() % int(size.x)) - (size.x/2) + center_pos.x
	random_position.y = (randi() % int(size.y)) - (size.y/2) + center_pos.y
	return random_position
