extends KinematicBody2D
#class_name Player


export(int) var RUN_SPEED = 150
export(int) var ACCELERATION = 20
export(int) var FRICTION = 15
export(int) var MAX_FALL_SPEED = 400
export(int) var DASH_SPEED = 600


export(float) var JUMP_HEIGHT = 100.0
export(float) var JUMP_TIME_TO_PEAK = 0.5
export(float) var JUMP_TIME_TO_DESCEND = 0.4

onready var jump_velocity : float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK * -1.0
onready var jump_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK) * -1.0
onready var fall_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCEND * JUMP_TIME_TO_DESCEND) * -1.0


onready var animationPlayer = $AnimationPlayer
# weapon needs to link to an interchangable weapon in the future. for now it's set on default
onready var weapon = get_node("Sprites/BackHand/WeaponPosition/DefaultGun")


var velocity = Vector2.ZERO
var dashing = false
var facing_right = true setget orient_sprites

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.y =  min(velocity.y, MAX_FALL_SPEED)
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("dash_right"):
		dash(1)
	elif Input.is_action_just_pressed("dash_left"):
		dash(-1)
	
	if input.x == 0:
		apply_friction()
		if is_on_floor():
			animationPlayer.play("Idle")
	else:
		apply_acceleration(input.x)
		if is_on_floor():
			animationPlayer.play("Run")
		
		if input.x > 0:
			if velocity.x < 0:
				velocity.x *= 0
		elif input.x < 0:
			if velocity.x > 0:
				velocity.x *= 0
	
	if Input.is_action_just_pressed("jump"):
			jump()
	
	if Input.is_action_pressed("fire"):
		weapon.fire()
	
	if not is_on_floor():
		animationPlayer.play("Jump")
	
	if dashing:
		velocity.y = -40
		velocity.y = move_toward(velocity.y, 0, (get_gravity() * delta) / 2)
	
	if self.global_position <= get_global_mouse_position():
		self.facing_right = true
	else:
		self.facing_right = false
	
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, RUN_SPEED * amount, ACCELERATION)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity
	if dashing:
		dashing = false
		velocity.x = velocity.x * 0.2

func dash(dir):
	dashing = true
	velocity.x = DASH_SPEED * dir
	yield(get_tree().create_timer(0.3), "timeout")
	dashing = false

func orient_sprites(right_is_new):
	if facing_right != right_is_new && right_is_new:
		facing_right = right_is_new
		animationPlayer.play("FlipRight")
	
	elif facing_right != right_is_new && !right_is_new:
		facing_right = right_is_new
		animationPlayer.play("FlipLeft")

