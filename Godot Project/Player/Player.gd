extends KinematicBody2D


export(int) var JUMP_FORCE = -180
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 100
export(int) var ACCELERATION = 20
export(int) var FRICTION = 15
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4
export(int) var MAX_FALL_SPEED = 200
export(int) var DASH_SPEED = 900

onready var animationPlayer = $AnimationPlayer
onready var leftFootSprite = $Sprites/LeftFoot
onready var rightFootSprite = $Sprites/RightFoot
onready var backHandSprite = $Sprites/BackHand
onready var bodySprite = $Sprites/Body
onready var frontHandSprite = $Sprites/FrontHand
onready var headSprite = $Sprites/Head

var velocity = Vector2.ZERO
var dashing = false


func _physics_process(delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		if is_on_floor():
			animationPlayer.play("Idle")
	else:
		apply_acceleration(input.x)
		if is_on_floor():
			animationPlayer.play("Walk")
		
		if input.x > 0:
			orient_sprites("right")
		elif input.x < 0:
			orient_sprites("left")
	
	if is_on_floor():                                             #remove commenting to make player only able to jump once
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
		animationPlayer.play("Jump")
		if Input.is_action_just_released("jump") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
	
	if velocity.y > 0:
		velocity.y += ADDITIONAL_FALL_GRAVITY
	
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y =  min(velocity.y, MAX_FALL_SPEED)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

func dash(dir):
	dashing = true
	velocity.x = DASH_SPEED * dir
	yield(get_tree().create_timer(0.3), "timeout")

#decide on the best way to flip sprites
func orient_sprites(direction):
	if direction == "right":
		#$Sprites.scale.x = 1
		leftFootSprite.flip_h = false
		rightFootSprite.flip_h = false
		backHandSprite.flip_h = false
		bodySprite.flip_h = false
		frontHandSprite.flip_h = false
		headSprite.flip_h = false
#		leftFootSprite.scale.x = 1
#		rightFootSprite.scale.x = 1
#		backHandSprite.scale.x = 1
#		bodySprite.scale.x = 1
#		frontHandSprite.scale.x = 1
#		headSprite.scale.x = 1
	elif direction == "left":
		#$Sprites.scale.x = -1
		leftFootSprite.flip_h = true
		rightFootSprite.flip_h = true
		backHandSprite.flip_h = true
		bodySprite.flip_h = true
		frontHandSprite.flip_h = true
		headSprite.flip_h = true
#		leftFootSprite.scale.x = -1
#		rightFootSprite.scale.x = -1
#		backHandSprite.scale.x = -1
#		bodySprite.scale.x = -1
#		frontHandSprite.scale.x = -1
#		headSprite.scale.x = -1
