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
	add_to_group("Persistent")
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
			player.attackDamage = playerNode.attackDamage
			player.attackCooldown = playerNode.attackCooldown
			player.specialDamage = playerNode.specialDamage
			player.specialCooldown = playerNode.specialCooldown
			if is_instance_valid(player.heldAxe):
				playerNode.heldAxe.queue_free()
			if is_instance_valid(player.armour_bar):
				player.armourPoints = playerNode.armourPoints
				player.bUlting = playerNode.bUlting
				player.armour_bar.value = player.armourPoints
		if(player.sceneKey == "Hydra"):
			player.currentAttack = playerNode.currentAttack
			player.fireDamage = playerNode.fireDamage 
			player.explosionDamage = playerNode.explosionDamage
			player.iceDamage = playerNode.iceDamage
			player.acidDamage = playerNode.acidDamage
			player.acidPoisonDamage = playerNode.acidPoisonDamage
			player.poisonTick = playerNode.poisonTick
			player.breathCooldown = playerNode.breathCooldown
			player.fireballCooldown = playerNode.fireballCooldown
			player.iceCooldown = playerNode.iceCooldown
			player.iceSpawns = playerNode.iceSpawns
			player.totalChain = playerNode.totalChain
			player.loadUI()
		
