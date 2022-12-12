extends Node2D

export(int) var cooldown = 30
export(int) var p_range = 30
export(int) var speed = 50
export(int) var damage = 1

export(PackedScene) onready var bullet
onready var aim_pos = get_node("AimPosition")

var last_shot = 0


func _physics_process(_delta):
	last_shot += 1
	look_at(get_global_mouse_position())
	rotation = clamp(rotation, -PI/4, PI/4)

func fire():
	if last_shot < cooldown: return
	else: last_shot = 0
	
	var projectile = bullet.instance()
	projectile.add_to_group("projectiles")
	get_node("/root").add_child(projectile)

	#projectile.add_to_group("Projectile_" + str(get_parent()))
	
	#var projectile_direction = aim_pos.global_position - self.global_position
	var projectile_direction = get_global_mouse_position() - self.global_position

	projectile.position = aim_pos.global_position
	projectile.rotation = projectile_direction.angle()
	projectile.projectile_direction = projectile_direction
	projectile.projectile_speed = speed
	projectile.damage = damage
	projectile.projectile_range = p_range
