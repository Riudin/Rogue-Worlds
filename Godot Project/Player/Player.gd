extends KinematicBody2D


export(int) var JUMP_FORCE = -250
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 100
export(int) var ACCELERATION = 20
export(int) var FRICTION = 15
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4
export(int) var MAX_FALL_SPEED = 200
export(int) var DASH_SPEED = 500

onready var animationPlayer = $AnimationPlayer
onready var leftFootSprite = $Sprites/LeftFoot
onready var rightFootSprite = $Sprites/RightFoot
onready var backHandSprite = $Sprites/BackHand
onready var bodySprite = $Sprites/Body
onready var frontHandSprite = $Sprites/FrontHand
onready var headSprite = $Sprites/Head

var velocity = Vector2.ZERO
var dashing = false
var facing_right = true setget orient_sprites

func _physics_process(delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("dash_right"):
		self.facing_right = true
		dash(1)
	elif Input.is_action_just_pressed("dash_left"):
		self.facing_right = false
		dash(-1)
	
	if input.x == 0:
		apply_friction()
		if is_on_floor():
			animationPlayer.play("Idle")
	else:
		apply_acceleration(input.x)
		if is_on_floor():
			animationPlayer.play("Walk")
		
		if input.x > 0:
			self.facing_right = true
		elif input.x < 0:
			self.facing_right = false
	
	if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
			
	
	if is_on_floor() == false:
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
	velocity.y = -40
	yield(get_tree().create_timer(0.3), "timeout")
	velocity.x = move_toward(velocity.x, 0, 0.05)
	dashing = false

func orient_sprites(right_is_new):
	if facing_right != right_is_new && right_is_new:
		facing_right = right_is_new
		animationPlayer.play("FlipRight")
	
	elif facing_right != right_is_new && !right_is_new:
		facing_right = right_is_new
		animationPlayer.play("FlipLeft")

