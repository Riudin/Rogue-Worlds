extends KinematicBody2D

const ItemDrop = preload("res://Items/ItemDrop.tscn")

export(int) var RUN_SPEED = 100
export(int) var ACCELERATION = 1200
export(int) var FRICTION = 25*60
export(int) var KNOCKBACK = 5
#export(int) var MAX_FALL_SPEED = 400
##export(int) var DASH_SPEED = 600
#
#export(float) var JUMP_HEIGHT = 100.0
#export(float) var JUMP_TIME_TO_PEAK = 0.5
#export(float) var JUMP_TIME_TO_DESCEND = 0.4
#
#onready var jump_velocity : float = (2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK * -1.0
#onready var jump_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK) * -1.0
#onready var fall_gravity : float = (-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCEND * JUMP_TIME_TO_DESCEND) * -1.0



export(int) var health = 10
#export(int) var speed = 500
export(int) var damage = 1
export(int) var gravity = 20
export(int) var projectile_range = 100
export(int) var projectile_speed = 400
export(bool) var projectile_piercing = false
export(bool) var projectile_stationary = false
export(int) var detection_radius = 1
export(float) var cooldown = 4.0
export(bool) var can_fly = false
export(bool) var can_pass_walls = false
export(String) var enemy_name
export(String, "normal", "boss") var enemy_type = "normal"
export(String) var boss_name = null
export(PackedScene) onready var projectile

enum {
	IDLE,
	CHASE,
	SHOOT,
	ATTACK
}

onready var ray_cast = $RayCast2D
onready var health_bar = $HealthBar
onready var sprite = $Sprite
onready var player_detection_zone = $PlayerDetectionZone
onready var attack_range = get_node_or_null("AttackRange")
onready var shoot_origin = get_node_or_null("ShootOrigin")
onready var attack_timer = get_node_or_null("AttackTimer")
onready var shoot_timer = get_node_or_null("ShootTimer")
onready var shoot_delay_timer = get_node_or_null("ShootDelayTimer")
onready var animation_player = $AnimationPlayer
onready var hitbox = $Hitbox
onready var soft_collision = $SoftCollision

var velocity = Vector2.ZERO
#var facing_right = true setget orient_sprites
var stun = false
var push_mod = 750
var direction = 1   #1 == right and -1 == left
var facing_right = true
var state = IDLE 
var can_shoot = true
var can_attack = true
var player = null setget new_player
var drop = false

func new_player(new_player):
	if new_player != null:
		player = new_player


func _ready():
	health = int(health) # not sure yet if we want health only as ints
	health_bar.max_value = health
	health_bar.value = health
	health_bar.set_as_toplevel(true)
	player_detection_zone.get_node("CollisionShape2D").scale.x *= detection_radius
	player_detection_zone.get_node("CollisionShape2D").scale.y *= detection_radius
	if enemy_type == "normal": boss_name = null
	if can_pass_walls:
		self.set_collision_mask(1)
	hitbox.damage = damage


func _process(_delta):
	health_bar.set_position(global_position - Vector2(6, 35))


func _physics_process(delta):
	if !shoot_origin: can_shoot = false       #just temporary to make non shooting enemies
	if !attack_range: can_attack = false      #for only shooting enemies
	if can_fly == false:
		velocity.y += gravity
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * push_mod
	
#	velocity.x = speed * direction
#	if ray_cast.is_colliding():
#		direction *= -1
	
	if stun == false:
		if facing_right: 
			ray_cast.scale.x = 1
			sprite.flip_h = true
			hitbox.scale.x = -1
		else:
			ray_cast.scale.x = -1
			sprite.flip_h = false
			hitbox.scale.x = 1
	
	velocity = move_and_slide(velocity)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_player.play("Move")
			seek_player()
			#check_wander_timer()
			
			
		
		#WANDER:
			#seek_player()
			#check_wander_timer()
			#wander_controller.start_positon = global_position
			#var direction = global_position.direction_to(wander_controller.target_position)
			#accelerate_to_point(wander_controller.target_position, delta)
			
			#if global_position.distance_to(wander_controller.target_position) <= 20:
			#	velocity = velocity.move_toward(direction * maxspeed * global_position.distance_to(wander_controller.target_position) / 5, ACCELERATION * delta)
			#	wander_controller.start_wander_timer(1)

				
				
			
			
		CHASE:
			if can_shoot:
				state = SHOOT
			elif can_attack:
				state = ATTACK
			self.player = player_detection_zone.player
			if player != null:
				accelerate_to_point(player.global_position, delta) #much better way of getting the right vector
				seek_player()
			else:
				state = IDLE
					
			
				
				
				
		SHOOT:
			self.player = player_detection_zone.player
			shoot_origin.look_at(player.global_position)
			if animation_player.current_animation == "Shoot":
				yield(animation_player, "animation_finished")
			fire()
			yield(animation_player, "animation_finished")
			seek_player()
		
		ATTACK:
			self.player = player_detection_zone.player
			attack()
			seek_player()


func attack():
	if can_attack:
		animation_player.play("Attack")
#		if facing_right:
#			animation_player.play("AttackRight")
#		else:
#			animation_player.play("AttackLeft")
		yield(animation_player, "animation_finished")
		can_attack = true


func fire():
	if can_shoot:
		can_shoot = false
		velocity = Vector2.ZERO
		animation_player.play("Shoot")
		var new_p = projectile.instance()
		var projectile_direction = shoot_origin.global_position.direction_to(player.global_position)
		get_node("/root").add_child(new_p)
		
		new_p.position = shoot_origin.global_position
		if projectile_stationary:
			new_p.rotation = 0
		else:
			new_p.rotation = projectile_direction.angle()
		new_p.projectile_direction = projectile_direction
		new_p.projectile_speed = projectile_speed
		new_p.damage = damage
		new_p.projectile_range = projectile_range
		new_p.piercing = projectile_piercing
		
		shoot_timer.start(cooldown)
#		can_shoot = true


func accelerate_to_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * RUN_SPEED, ACCELERATION * delta)
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	animation_player.play("Move")


func seek_player():
	if player_detection_zone.can_see_player():
		if can_shoot:
			state = SHOOT
		elif attack_range and attack_range.player_in_attack_range():
			if can_attack:
				state = ATTACK
		else:	
			state = CHASE


func apply_damage(dmg):
	health -= dmg
	health_bar.visible = true
	health_bar.value = health
	if stun == false:
		apply_stun(0.3)
	if health <= 0:
		on_destroy()


func apply_stun(time):
	velocity = - velocity * KNOCKBACK
	if velocity == Vector2.ZERO:
		if player.global_position.x < self.global_position.x:
			velocity.x = 200
		elif player.global_position.x > self.global_position.x:
			velocity.x = -200
#	sprite.modulate = Color.red
	stun = true
	$StunTimer.set_wait_time(time)
	$StunTimer.start()


func _on_StunTimer_timeout():
	stun = false


func on_destroy():
	drop_loot()
	queue_free()


func drop_loot():
	var loot_table = JsonData.drop_data[enemy_name]
	randomize()
	for item in loot_table:
		var drop_chance = loot_table[item][1]
		var rng = randi() % 100 + 1
		if rng <= drop_chance:
			var new_item_drop = ItemDrop.instance()
			new_item_drop.item_name = loot_table[item][0]
			new_item_drop.item_quantity = randi() % int(loot_table[item][2]) + 1
			new_item_drop.position = self.global_position + Vector2(int(rand_range(-8, 8)), int(rand_range(-8, 8)))
			get_tree().get_root().get_node("Main").call_deferred("add_child", new_item_drop)


func _on_ShootTimer_timeout():
	can_shoot = true


func _on_AttackTimer_timeout():
	can_attack = true


func get_class(): return "Enemy" # used for collision detection
func is_class(name): return name == "Enemy" or .is_class(name)


func _on_ShootDelayTimer_timeout():
	pass # Replace with function body.
