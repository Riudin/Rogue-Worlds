extends Node

onready var groundSpawners = $Groundspawners
#onready var airSpawners = $AirSpawners
onready var airSpawn1 = $AirSpawners/AirSpawn
onready var groundSpawn1 = $Groundspawners/GroundSpawn1
onready var groundSpawn2 = $Groundspawners/GroundSpawn2
onready var groundSpawn3 = $Groundspawners/GroundSpawn3

var enemies = [["BloodWorm", 10], ["EyeDude", 10]]

var ground_spawn = []
var air_spawn = []

func _ready():
	#get_spawn_areas()
	spawn_enemies()


func spawn_enemies():
	for e in enemies:
		var enemy = load("res://Enemies/" + e[0] + ".tscn")
		var number_of_enemies = e[1]
		for n in number_of_enemies:
			var new_enemy = enemy.instance()
			var new_enemy_can_fly = new_enemy.can_fly
			var new_enemy_position = generate_enemy_position(new_enemy_can_fly)
			new_enemy.position = new_enemy_position
			add_child(new_enemy)

func get_spawn_areas():
	for c in groundSpawners.get_child_count():
		ground_spawn.append()
		

func generate_enemy_position(can_fly):
	var enemy_position
	if can_fly:
		enemy_position = airSpawn1.get_random_position()
	else:
		randomize()
		var rng = randi() % 3 + 1
		var active_spawner
		if rng == 1:
			active_spawner = groundSpawn1
		elif rng == 2:
			active_spawner = groundSpawn2
		elif rng == 3:
			active_spawner = groundSpawn3
		enemy_position = active_spawner.get_random_position()
	return enemy_position
