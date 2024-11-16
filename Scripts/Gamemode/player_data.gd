extends Node

var playerNode : CharacterBody2D
var playerScene : PackedScene

var character_versions = {
	"Wisp" : preload("res://Scenes/PlayerClasses/player_wisp.tscn"),
	"Minotaur" : preload("res://Scenes/PlayerClasses/minotaur.tscn"),
	"Hydra" : preload("res://Scenes/PlayerClasses/hydra.tscn")
}

var playerKey : String

func _ready() -> void:
	loadPlayerInfo(playerNode)
	
func savePlayerInfo(key : String, player : CharacterBody2D) ->void:
	if character_versions.has(key):
		playerScene = character_versions[key]
		playerNode = player
		
	
func loadPlayerInfo(player : CharacterBody2D) -> void:
	if is_instance_valid(playerScene):
		player.health = playerNode.health
		player.hp_bar.value = playerNode.health
		if(player.sceneKey == "Minotaur"):
			if is_instance_valid(player.heldAxe):
				playerNode.heldAxe.queue_free()
			if is_instance_valid(player.armour_bar):
				player.armourPoints = playerNode.armourPoints
				player.armour_bar.value = player.armourPoints
		
