extends Node

var item_data: Dictionary
var drop_data: Dictionary

func _ready():
	item_data = LoadData("res://Data/ItemData.json")
	drop_data = LoadData("res://Data/DropData.json")

func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
