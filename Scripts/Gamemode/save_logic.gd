extends Node

const save_DIR = "user://saves_"
const ENCRYPTION_KEY = "13082018040320031807200301122022"
const IV = "aywnbyeitmflutwa"
#Script that creates and stores the logic for the world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Persistent")


func pad_data(data : String) -> PackedByteArray:
	var padded_data = data.to_utf8_buffer()
	while padded_data.size() % 16 != 0:
		padded_data.append(32)
	return padded_data
	
func unpad_data(data : PackedByteArray) -> String:
	return data.get_string_from_utf8().strip_edges()
			
func encrypt_data(data: String) -> PackedByteArray:
	var aes = AESContext.new()
	aes.start(AESContext.MODE_CBC_ENCRYPT, ENCRYPTION_KEY.to_utf8_buffer(), IV.to_utf8_buffer())
	var encrypted = aes.update(pad_data(data))
	return encrypted

func decrypt_data(data : PackedByteArray) -> String:
	var aes = AESContext.new()
	aes.start(AESContext.MODE_CBC_DECRYPT, ENCRYPTION_KEY.to_utf8_buffer(), IV.to_utf8_buffer())
	return unpad_data(aes.update(data))
	
func write_encrypted_data(slot : int, data : Dictionary) -> void: #Does all logic for encrypting the data
	var save_path = "%ssave_slot_%d.dat" % [save_DIR, slot] #Path that data will be saved at. In users APPDATA/Roaming/GODOT/gameName/_save
	
	var json_text = JSON.stringify(data) #Converts dictionary to json string
	var encrypted_data = encrypt_data(json_text) #encrypts string
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE) #accesses and writes encrypted string to file
	if save_file:
		save_file.store_buffer(encrypted_data)
		save_file.close()
	
	
func read_encrypted_data(slot : int) -> Variant:
	var save_path = "%ssave_slot_%d.dat" % [save_DIR, slot]
	
	if !FileAccess.file_exists(save_path): #If no file returns null
		return null
	
	var save_file = FileAccess.open(save_path, FileAccess.READ) 
	if save_file == null:
		return null
	
	var encrypted_data = save_file.get_buffer(save_file.get_length()) #gets the encrypted data
	save_file.close()
	var decrypted_data = decrypt_data(encrypted_data) #decrypts data for use
	var decrypted_JSON = JSON.parse_string(decrypted_data) #parses data back into a format acceptable as a dictionary
	
	return decrypted_JSON
		

func setButtonDetails(button : TextureButton, slot : int)-> void:
	var save_data = read_encrypted_data(slot)
	
	if save_data == null:
		button.get_child(0).text = "Empty"
		return
	
	button.get_child(0).text = "%s\nRuns: %d" % [save_data["save_name"], save_data["no_runs"]]
	
func save_game(slot: int, save_name : String) -> void:
	var dir = DirAccess.open(save_DIR)
	if dir == null:
		DirAccess.make_dir_absolute(save_DIR)
	var save_data = { #Saves level data using this dict
		"save_name" : save_name,
		"game_data" : Gamemode.activePodiums,
		"no_runs" : Gamemode.runCount
	}
	
	write_encrypted_data(slot, save_data)

func load_game_sprite(slot : int) -> bool:
	var save_data = read_encrypted_data(slot) #Gets decrypted data from save file
	
	if save_data == null:
		return false
		
	Gamemode.activePodiums = save_data["game_data"]
	return true
	
func load_game(slot: int) -> bool:
	var save_data = read_encrypted_data(slot) #Calls decrypting function to get data as a Dictionary
	if save_data == null:
		get_tree().root.get_node("mainMenu/CanvasLayer/menu").nameSavePrompt(slot)
		return false
	
	Gamemode.activePodiums = save_data["game_data"]
	Gamemode.runCount = save_data["no_runs"]
	Gamemode.saveName = save_data["save_name"]
	return true
		
func delete_save(slot : int) -> void: #Finds save slot and its location and removes it
	var filename = "save_slot_%d" % [slot] #Filename is needed for removal not full path
	var full_path = "%s%s" % [save_DIR, filename]
	
	if !FileAccess.file_exists(full_path): #ensures the file being searched for is valid
		return
	var dir = DirAccess.open(save_DIR) #Ensures the directory is valid
	if dir == null:
		return
	
	dir.remove(filename) #removes the file of filename from that directory
