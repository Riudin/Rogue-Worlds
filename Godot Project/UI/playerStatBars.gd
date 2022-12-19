extends Node2D


onready var health_bar = $TextureRect/VBoxContainer/HealthBar/ProgressBar
onready var health_label = $TextureRect/VBoxContainer/HealthBar/Label
onready var mana_bar = $TextureRect/VBoxContainer/ManaBar/ProgressBar
onready var mana_label = $TextureRect/VBoxContainer/ManaBar/Label

var player_health = 5
var player_max_health = 5
var player_mana = 5
var player_max_mana = 5


func _ready():
	Events.connect("player_health_changed", self, "_on_player_health_changed")
	Events.connect("player_max_health_changed", self, "_on_player_max_health_changed")


func _on_player_max_health_changed(new_max_health):
	player_max_health = new_max_health
	health_bar.max_value = player_max_health
	health_label.text = str(player_health) + "/" + str(player_max_health)


func _on_player_health_changed(new_health):
	player_health = new_health
	health_bar.value = player_health
	health_label.text = str(player_health) + "/" + str(player_max_health)
