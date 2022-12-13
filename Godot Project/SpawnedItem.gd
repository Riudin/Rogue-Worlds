extends KinematicBody2D

export(Resource) var item_resource

var velocity = Vector2.ZERO
var player_detected = false
var speed = 120
var being_picked_up = false

onready var player = get_node("/root/World/Player")
onready var playerDetectionZone = $PlayerDetectionZone
onready var pickupRange = $PlayerDetectionZone


func _ready():
	item_resource = item_resource.duplicate()
	Events.connect("item_pick_up_successful", self, "_on_item_pick_up_successful")

func _physics_process(delta):
	if not being_picked_up:
		if playerDetectionZone.can_see_player():
			player_detected = true
		
		if player_detected:
			velocity = player.global_position - self.global_position
			velocity = velocity.normalized() * speed
	
	
	velocity = move_and_slide(velocity)


func pick_up():
	Events.emit_signal("item_picked_up", item_resource)
	being_picked_up = true
	player_detected = false
	velocity = Vector2.ZERO
#	yield(get_tree().create_timer(2), "timeout")       #uncomment if we want the item to follow the player again
#	being_picked_up = false

func _on_item_pick_up_successful(item):
	if item == self.item_resource:
		queue_free()

func _on_Area2D_body_entered(body):
	pick_up()
