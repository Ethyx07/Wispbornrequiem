extends Node

const save_DIR = "user://saves_"

#Script that creates and stores the logic for the world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Persistent")

func setButtonDetails(button : TextureButton, slot : int)-> void:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot] #Finds save path and checks if it can be opened
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file: #If there is a valid save file it accesses the save data
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
		save_file.close()
		button.get_child(0).text =save_data["save_name"] + "\nRuns: " + str(save_data["no_runs"]) #Uses the save data dict to display the save name and runs on main button screen
		
	else:
		button.get_child(0).text = "Empty" #No text if no save
	
func save_game(slot: int, save_name : String) -> void:
	var dir = DirAccess.open(save_DIR)
	if dir == null:
		DirAccess.make_dir_absolute(save_DIR)
		
	var save_data = { #Saves level data using this dict
		"save_name" : save_name,
		"game_data" : Gamemode.activePodiums,
		"no_runs" : Gamemode.runCount
	}
	
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE) #Writes new save file to the save path
	if save_file:
		save_file.store_string(JSON.stringify(save_data, "\t")) #Stringifies the save data for storage
		save_file.close()

func load_game_sprite(slot : int) -> bool:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if !FileAccess.file_exists(save_path):
		return false
	var save_file = FileAccess.open(save_path, FileAccess.READ) #Reads file at path
	if save_file:
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
		save_file.close()
		Gamemode.activePodiums = save_data["game_data"] #Sets gamemode logic for the active podiums based on save data
	return true
	
func load_game(slot: int) -> bool:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if !FileAccess.file_exists(save_path):
		get_tree().root.get_node("mainMenu/CanvasLayer/menu").nameSavePrompt(slot) #If no save slot then the game prompts player to name the save before loading
		return false
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file:
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path)) #if its been created before, it sets the game data based on save data
		save_file.close()
		Gamemode.activePodiums = save_data["game_data"]
		Gamemode.runCount = save_data["no_runs"]
		Gamemode.saveName = save_data["save_name"]
	return true
		
func delete_save(slot : int) -> void: #Finds save slot and its location and removes it
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if FileAccess.file_exists(save_path): #Makes sure file does exist
		var dir = DirAccess.open(save_DIR) #Has to open it to sure its not null
		if dir != null:
			dir.remove(save_path)
