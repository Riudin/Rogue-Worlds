extends Area2D


export(String, "hostile", "friendly") var projectile_type := "hostile"

onready var sprite = $Sprite

var projectile_direction := Vector2.ZERO
var projectile_speed
var damage
var projectile_range

var _ticks = 0


func _ready():
	sprite.playing = true
	self.connect("area_entered", self, "_on_impact")
	self.connect("body_entered", self, "_on_impact")


func _physics_process(delta):
	_ticks += 1
	if _ticks > projectile_range: destroy()
	else: global_position += projectile_speed * projectile_direction.normalized() * delta


func destroy():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func _on_impact(target):
	#janky af. this is just until collision layers are configured
	if target.get_class() == "Player": return
	if target.is_in_group("projectiles"): return
	if target.is_in_group("terrain"): return
	if projectile_type == "friendly":
		if (target.get_class() == "Enemy"):
			target.apply_damage(damage)
#	if projectile_type == "hostile":
#		if (target.get_parent().get_class() == "Player"):
#			target.get_parent().apply_damage(damage)
	destroy()
