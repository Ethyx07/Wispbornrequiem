extends Node

const save_DIR = "user://saves_"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


	
func save_game(slot: int) -> void:
	var dir = DirAccess.open(save_DIR)
	if dir == null:
		DirAccess.make_dir_absolute(save_DIR)
		
	var save_data = {
		"save_name" : "Save %d" % slot,
		"save_date" : Time.get_time_string_from_system(),
		"game_data" : Gamemode.activePodiums
	}
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(save_data, "\t"))
		save_file.close()
		
	
func load_game(slot: int) -> void:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if !FileAccess.file_exists(save_path):
		return
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file:
		var save_data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
		save_file.close()
		Gamemode.activePodiums = save_data["game_data"]
		
		
func delete_save(slot : int) -> void:
	var save_path = "%ssave_slot_%d.JSON" % [save_DIR,slot]
	if FileAccess.file_exists(save_path):
		var dir = DirAccess.open(save_DIR)
		if dir != null:
			dir.remove(save_path)
