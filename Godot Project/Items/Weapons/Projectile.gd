extends Area2D


export(String, "hostile", "friendly") var projectile_type := "hostile"

onready var animated_sprite = get_node_or_null("AnimatedSprite")

var projectile_direction := Vector2.ZERO
var projectile_speed
var damage
var projectile_range
var piercing = false

var _ticks = 0


func _ready():
	self.connect("area_entered", self, "_on_impact")
	self.connect("body_entered", self, "_on_impact")
	if animated_sprite:
		animated_sprite.frame = 0
		animated_sprite.playing = true


func _physics_process(delta):
	_ticks += 1
	if _ticks > projectile_range: destroy()
	else: global_position += projectile_speed * projectile_direction.normalized() * delta


func destroy():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func _on_impact(target):
	if projectile_type == "friendly":
		if (target.get_class() == "Enemy"):
			target.apply_damage(damage)
	if projectile_type == "hostile":
		if (target.get_class() == "Player"):
			target.apply_damage(damage)
	if piercing == false:
		destroy()
