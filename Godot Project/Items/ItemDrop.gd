extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name = "BloodItemSmall"
var item_quantity = 1

var player = null
var being_picked_up = false

onready var animationPlayer = $AnimationPlayer
onready var itemTexture = $ItemTexture

func _ready():
	itemTexture.texture = load("res://Items/Assets/" + item_name + ".png")
	animationPlayer.play("Float")
	
func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0, 0), ACCELERATION * delta)
	else:
		var direction = global_position.direction_to(player.global_position - Vector2(8, 16))
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position - Vector2(8, 16))
		if distance < 16:
			PlayerInventory.add_item(item_name, item_quantity)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
