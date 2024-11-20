extends Node

var dungeon_levels_generator = []
var dungeon_levels = ["res://Scenes/level_1.tscn", "res://Scenes/level_2.tscn"]
var boss_level = "res://Scenes/corrupt_dragon_arena.tscn"
var currentLevel : int = 0

var saveSlot : int
var saveName : String
var runCount = 0

var activePodiums = {
	"Minotaur" : true,
	"Hydra" : false
}

func _ready() -> void:
	add_to_group("Persistent")
	dungeon_levels_generator = dungeon_levels.duplicate()
	dungeon_levels_generator.shuffle()
	

func load_level() -> void:
	var projectiles = get_tree().get_nodes_in_group("Projectile")
	for proj in projectiles:
		proj.queue_free()
	if dungeon_levels_generator.size() > currentLevel:
		get_tree().change_scene_to_file(dungeon_levels_generator[currentLevel])
		currentLevel += 1
	else:
		get_tree().change_scene_to_file(boss_level)
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
