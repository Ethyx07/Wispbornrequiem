extends Node

var dungeon_levels_generator = []
var dungeon_levels = ["res://Scenes/Levels/level_1.tscn", "res://Scenes/Levels/level_2.tscn", "res://Scenes/Levels/level_3.tscn","res://Scenes/Levels/level_1.tscn", "res://Scenes/Levels/level_2.tscn", "res://Scenes/Levels/level_3.tscn", "res://Scenes/Levels/level_1.tscn", "res://Scenes/Levels/level_2.tscn", "res://Scenes/Levels/level_3.tscn", "res://Scenes/Levels/level_1.tscn", "res://Scenes/Levels/level_2.tscn", "res://Scenes/Levels/level_3.tscn"]

var dungeon_area = {"level_generator" : dungeon_levels,
					"mini_boss" : "res://Scenes/corrupt_dragon_arena.tscn",
					"final_boss" : "res://Scenes/huntsman_boss_arena.tscn"}
var forest_area = {"level_generator" : dungeon_levels,					#Dictionary for the areas
					"mini_boss" : "res://Scenes/corrupt_dragon_arena.tscn",
					"final_boss" : "res://Scenes/huntsman_boss_arena.tscn"}

var area_dict = {"dungeon" : dungeon_area, #Dictionary of the dictionaries
				"forest" : forest_area}
var area_key = "dungeon"
var currentLevel : int = 0

var saveSlot : int
var saveName : String
var runCount = 0

var HydraLoot = ["res://Scripts/Upgrades/Hydra/ice_spawnBuff.tres", "res://Scripts/Upgrades/Hydra/ice_damageBuff.tres"]
var MinotaurLoot = ["res://Scripts/Upgrades/Minotaur/axe_damageBuff.tres", "res://Scripts/Upgrades/Minotaur/axe_throwDamageBuff.tres"]

var lootTableDict = {
	"Minotaur" : MinotaurLoot,
	"Hydra" : HydraLoot
}

var runtimeLootTable

var activePodiums = {
	"Minotaur" : true,
	"Hydra" : false
}

func _ready() -> void:
	add_to_group("Persistent")
	

func load_level() -> void:
	var projectiles = get_tree().get_nodes_in_group("Projectile")
	for proj in projectiles:
		proj.queue_free()
	
	get_tree().change_scene_to_file(area_dict[area_key]["level_generator"][currentLevel])
	currentLevel += 1
	
	var player = PlayerData.playerScene.instantiate()
	get_tree().root.add_child(player)
	PlayerData.loadPlayerInfo(player)
	
	
func respawn() -> void:
	runCount += 1
	var projectiles = get_tree().get_nodes_in_group("Projectile")
	for proj in projectiles:
		proj.queue_free()
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.call_deferred("remove_self")
	get_tree().get_first_node_in_group("Player").call_deferred("remove_self")
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/hub_scene.tscn")
	
func populateLootTable(key : String) -> void:
	runtimeLootTable = lootTableDict[key].duplicate()

func levelGenerator() -> void: #Level generation function, takes the level dictionary for the area
	area_dict[area_key]["level_generator"].shuffle() #Duplicates said dungeon and shuffles it randomly
	while area_dict[area_key]["level_generator"].size() > 2: #Out of the 15 levels it keeps the first 8
		area_dict[area_key]["level_generator"].pop_back()
	var midPoint = (area_dict[area_key]["level_generator"].size()/2) #Value for the mini boss index, after the halfway point minimum
	var miniBossIndex = randi_range(midPoint, area_dict[area_key]["level_generator"].size()) #Sets its mini boss level
	area_dict[area_key]["level_generator"].insert(miniBossIndex, area_dict[area_key]["mini_boss"])
	area_dict[area_key]["level_generator"].append(area_dict[area_key]["final_boss"]) #Adds the final boss to the end of the index
	print(area_dict[area_key]["level_generator"])
