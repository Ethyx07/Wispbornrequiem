extends Node

var dungeon_levels_generator = []
var dungeon_levels = ["res://Scenes/level_1.tscn", "res://Scenes/level_2.tscn"]
var boss_level = "res://Scenes/corrupt_dragon_arena.tscn"
var currentLevel : int = 0

var saveSlot : int
var saveName : String

var activePodiums = {
	"Minotaur" : true,
	"Hydra" : false
}

func _ready() -> void:
	#for i in range(5):
		#var randNum = randi_range(0, 1)
		#dungeon_levels_generator.append(randNum)
	dungeon_levels_generator = dungeon_levels.duplicate()
	dungeon_levels_generator.shuffle()
	print("done")

func load_level() -> void:
	if dungeon_levels_generator.size() > currentLevel:
		get_tree().change_scene_to_file(dungeon_levels_generator[currentLevel])
		currentLevel += 1
	else:
		get_tree().change_scene_to_file(boss_level)
	var player = PlayerData.playerScene.instantiate()
	get_tree().root.add_child(player)
	PlayerData.loadPlayerInfo(player)
