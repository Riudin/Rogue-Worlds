extends Node

var item_data: Dictionary

func _ready():
	item_data = {
  "BloodItemSmall": {
	"ItemCategory": "Resource",
	"StackSize": 99,
	"Description": "A drop of Blood that can be used for crafting."
  },
  "EyeItemSmall": {
	"ItemCategory": "Resource",
	"StackSize": 99,
	"Description": "A mysterious Eye that can be used for crafting."
  }
}
	#item_data = LoadData("res://Data/ItemData.json")

func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
