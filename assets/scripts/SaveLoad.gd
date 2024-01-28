class_name SaverLoader
extends Node
@onready var jogador = %Jogador

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	saved_game.player_health = jogador.health
	saved_game.player_hasBaloon = jogador.hasBaloon
	ResourceSaver.save(saved_game,"user://savegame.tres")

func load_game():
	var saved_game:SavedGame = load("user://savegame.tres") as SavedGame
	jogador.health = saved_game.player_health 
	jogador.hasBaloon = saved_game.player_hasBaloon

