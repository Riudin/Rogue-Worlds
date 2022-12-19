extends KinematicBody2D


export(int) var RUN_SPEED = 150
export(int) var ACCELERATION = 20
export(int) var AIR_FRICTION = 10
export(int) var GROUND_FRICTION = 25
export(int) var MAX_FALL_SPEED = 350
export(int) var DASH_SPEED = 400
export(int) var DASH_UPWARDS_MOTION = 20
export(int) var KNOCKBACK = 5
export(int) var MAX_HEALTH = 5
export(int) var HEALTH = 5

export(float) var JUMP_HEIGHT = 10.0
export(float) var JUMP_TIME_TO_PEAK = 0.5
export(float) var JUMP_TIME_TO_DESCEND = 0.4

onready var jump_velocity : float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK * -1.0
onready var jump_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK) * -1.0
onready var fall_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCEND * JUMP_TIME_TO_DESCEND) * -1.0

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var stun_timer = $StunTimer
onready var weapon_pos = $Sprites/BackHand/WeaponPosition
onready var screen_shaker = $Camera2D/ScreenShaker
onready var pickupZone = $PickupZone
# weapon needs to link to an interchangable weapon in the future. for now it's set on default
onready var weapon = weapon_pos.get_child(0)
#export(PackedScene) onready var weapon

var velocity = Vector2.ZERO
var dashing = false
var stun = false
var facing_right = true setget orient_sprites
var FRICTION = 25
var inventory_open = false
var alive = true


func _ready():
	animation_tree.active = true
	Events.connect("inventory_opened", self, "_on_inventory_opened")
	set_health_ui()


func set_health_ui():
	Events.emit_signal("player_max_health_changed", MAX_HEALTH)
	Events.emit_signal("player_health_changed", HEALTH)


func _physics_process(delta):
	if not is_on_floor():
		FRICTION = AIR_FRICTION
	else:
		FRICTION = GROUND_FRICTION
	velocity.y += get_gravity() * delta
	velocity.y =  min(velocity.y, MAX_FALL_SPEED)
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("dash_right") and alive:
		dash(1)
	elif Input.is_action_just_pressed("dash_left") and alive:
		dash(-1)
	
	if input.x == 0:
		apply_friction()
		if is_on_floor():
			animation_tree.set("parameters/movement/current", 0)
			
	elif alive:
		apply_acceleration(input.x)
		if is_on_floor():
			animation_tree.set("parameters/movement/current", 1)
		
		if input.x > 0:
			if velocity.x < 0:
				velocity.x *= 0
		elif input.x < 0:
			if velocity.x > 0:
				velocity.x *= 0
	
	if Input.is_action_just_pressed("jump") and alive:
			jump()
	
	if Input.is_action_pressed("fire") and not inventory_open and alive:
		weapon.start_fire_animation()
		var weapon_recoil = weapon.get_recoil()
		if facing_right and weapon.can_fire:
			velocity.x -= weapon_recoil
		elif not facing_right and weapon.can_fire:
			velocity.x += weapon_recoil
	
	if is_on_floor():
		animation_tree.set("parameters/in_air_state/current", 0)
	else:
		animation_tree.set("parameters/in_air_state/current", 1)
	
	if dashing:
		velocity.y = -DASH_UPWARDS_MOTION
		velocity.y = move_toward(velocity.y, 0, (get_gravity() * delta) / 2)
	
	if self.global_position <= get_global_mouse_position():
		self.facing_right = true
	else:
		self.facing_right = false
	
	#if stun: velocity = Vector2.ZERO
	#activate for stun
	
	if pickupZone.items_in_range.size() > 0:
		var pickup_item = pickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		pickupZone.items_in_range.erase(pickup_item)
	
	
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
	if dir >= 0:
		animation_tree.set("parameters/dash_direction/current", 0)
	elif dir < 0:
		animation_tree.set("parameters/dash_direction/current", 1)
	animation_tree.set("parameters/in_air/current", 1)
	yield(get_tree().create_timer(0.3), "timeout")
	dashing = false


func apply_damage(dmg):
	if alive: 
		HEALTH -= dmg
	if stun == false:
		apply_stun(0.3)
	if HEALTH <= 0 and alive:
		HEALTH = 0
		on_death()
	Events.emit_signal("player_health_changed", HEALTH)


func apply_stun(time):
	#velocity = -velocity * KNOCKBACK
	#if velocity == Vector2.ZERO:
	#needs to be handled
	#also does nothing atm. enable just before move_and_slide funcion in _physics_process
	stun = true
	$StunTimer.set_wait_time(time)
	$StunTimer.start()


func on_death():
	animation_tree.set("parameters/alive_state/current", 1)
	alive = false
	Events.emit_signal("player_died")
#	yield(get_tree().create_timer(3), "timeout")
#	Transition.transition("res://MainScenes/Main.tscn")


func orient_sprites(right_is_new):
	if not alive:
		facing_right = true
		return
	
	if facing_right != right_is_new && right_is_new:
		facing_right = right_is_new
		animation_player.play("FlipRight")
	
	elif facing_right != right_is_new && !right_is_new:
		facing_right = right_is_new
		animation_player.play("FlipLeft")


func get_class(): return "Player" # used for collision detection
func is_class(name): return name == "Player" or .is_class(name)

func _on_inventory_opened(inventory_state):
	inventory_open = inventory_state


func _on_StunTimer_timeout():
	stun = false
