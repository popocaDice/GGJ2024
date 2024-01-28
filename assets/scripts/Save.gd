class_name SaverLoader
extends Node
@onready var jogador = %Jogador

func save_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var saved_data = {}
	saved_data["jogador.hasBaloon"] = jogador.hasBaloon
	saved_data["jogador.health"] = jogador.health
	
	var json = JSON.stringify(saved_data)
	file.store_string(json)
	file.close()

func load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var json = file.get_as_text()
	var saved_data = JSON.parse_string(json)
	jogador.hasBaloon = saved_data["jogador.hasBaloon"]
	jogador.health = saved_data["jogador.health"]
	file.close()

