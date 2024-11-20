extends Node

const save_DIR = "user://saves_"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Persistent")

func setButtonDetails(button : Button, slot : int)-> void:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file:
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
		save_file.close()
		button.text = save_data["save_name"] + "\n Runs: " + str(save_data["no_runs"])
		
	else:
		button.text = "Empty Save"
	
func save_game(slot: int, save_name : String) -> void:
	var dir = DirAccess.open(save_DIR)
	if dir == null:
		DirAccess.make_dir_absolute(save_DIR)
		
	var save_data = {
		"save_name" : "Save %s" % save_name,
		"game_data" : Gamemode.activePodiums,
		"no_runs" : Gamemode.runCount
	}
	
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(save_data, "\t"))
		save_file.close()
		
	
func load_game(slot: int) -> bool:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if !FileAccess.file_exists(save_path):
		get_tree().root.get_node("mainMenu/CanvasLayer/menu").nameSavePrompt(slot)
		return false
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file:
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
		save_file.close()
		Gamemode.activePodiums = save_data["game_data"]
		Gamemode.runCount = save_data["no_runs"]
	return true
		
func delete_save(slot : int) -> void:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if FileAccess.file_exists(save_path):
		var dir = DirAccess.open(save_DIR)
		if dir != null:
			dir.remove(save_path)
