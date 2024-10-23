extends Node

var playerNode : CharacterBody2D
var playerScene : PackedScene

var character_versions = {
	"Wisp" : preload("res://Scenes/PlayerClasses/player_wisp.tscn"),
	"Minotaur" : preload("res://Scenes/PlayerClasses/minotaur.tscn")
}

var playerKey : String

	
func savePlayerInfo(key : String, player : CharacterBody2D) ->void:
	if character_versions.has(key):
		playerScene = character_versions[key]
		playerNode = player
		
	
func loadPlayerInfo(player : CharacterBody2D) -> void:
	if is_instance_valid(playerScene):
		player.health = playerNode.health
