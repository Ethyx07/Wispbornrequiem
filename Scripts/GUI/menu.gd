extends Control

@onready var saveMenu = get_node("saveMenu")
@onready var mainMenu = get_node("mainMenu")
@onready var loadButtons = get_node("saveMenu/loadDelete")
@onready var loadSaveButton = get_node("saveMenu/loadDelete/loadSave")
@onready var deleteSaveButton = get_node("saveMenu/loadDelete/deleteSave")
@onready var doubleCheck = get_node("dCheckContainer")
@onready var saveOne = get_node("saveMenu/saveOne")
@onready var saveTwo = get_node("saveMenu/saveTwo")
@onready var saveThree = get_node("saveMenu/saveThree")
var selectedSave : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$mainMenu/VertContainer/PlayButton.grab_focus()
	var styleBoxOne = StyleBoxFlat.new() # Replace with function body.
	var styleBoxTwo = StyleBoxFlat.new()
	var styleBoxThree = StyleBoxFlat.new()
	
	saveOne.add_theme_stylebox_override("normal", styleBoxOne)
	saveTwo.add_theme_stylebox_override("normal", styleBoxTwo)
	saveThree.add_theme_stylebox_override("normal", styleBoxThree)
	saveOne.get_theme_stylebox("normal").border_width_left = 1
	saveOne.get_theme_stylebox("normal").border_width_right = 1
	saveOne.get_theme_stylebox("normal").border_width_top = 1
	saveOne.get_theme_stylebox("normal").border_width_bottom = 1
	
	saveTwo.get_theme_stylebox("normal").border_width_left = 1
	saveTwo.get_theme_stylebox("normal").border_width_right = 1
	saveTwo.get_theme_stylebox("normal").border_width_top = 1
	saveTwo.get_theme_stylebox("normal").border_width_bottom = 1
	
	saveThree.get_theme_stylebox("normal").border_width_left = 1
	saveThree.get_theme_stylebox("normal").border_width_right = 1
	saveThree.get_theme_stylebox("normal").border_width_top = 1
	saveThree.get_theme_stylebox("normal").border_width_bottom = 1
	
	updateSaveData()
	
func _on_play_button_pressed() -> void:
	mainMenu.hide()
	saveMenu.show()
	$saveMenu/saveOne.grab_focus()
	loadButtons.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_save_one_pressed() -> void:
	selectedSave = 1
	saveOne.grab_focus()

func _on_save_two_pressed() -> void:
	selectedSave = 2
	saveTwo.grab_focus()

func _on_save_three_pressed() -> void:
	selectedSave = 3 
	saveThree.grab_focus()

func _on_load_save_pressed() -> void:
	loadGame(selectedSave)

func _on_delete_save_pressed() -> void:
	doubleCheck.show()
	toggleButtonDisable(true)
	
func _on_yes_delete_pressed() -> void:
	SaveLogic.delete_save(selectedSave)
	updateSaveData()
	doubleCheck.hide()
	toggleButtonDisable(false)
	
func _on_no_dont_pressed() -> void:
	doubleCheck.hide()
	toggleButtonDisable(false)
	
func nameSavePrompt(slot : int) -> void:
	get_node("setSaveName").show()
	toggleButtonDisable(true)
	Gamemode.saveSlot = slot
	
func loadGame(slot : int) -> void:
	if SaveLogic.load_game(slot):
		Gamemode.saveSlot = slot
		openHub()

func openHub() -> void:
	get_tree().change_scene_to_file("res://Scenes/hub_scene.tscn")

func updateSaveData() -> void:
	SaveLogic.setButtonDetails(saveOne, 1)
	SaveLogic.setButtonDetails(saveTwo, 2)
	SaveLogic.setButtonDetails(saveThree, 3)
	
func _on_set_name_pressed() -> void:
	if get_node("setSaveName/nameGrabber").text.length() > 0:
		Gamemode.saveName = get_node("setSaveName/nameGrabber").text
		SaveLogic.save_game(selectedSave, Gamemode.saveName)
		get_node("setSaveName/nameGrabber").text = ""
		get_node("setSaveName").hide()
		toggleButtonDisable(false)
		updateSaveData()
		
func toggleButtonDisable(dis : bool)-> void:
	loadSaveButton.disabled = dis
	deleteSaveButton.disabled = dis
	saveOne.disabled = dis
	saveTwo.disabled = dis
	saveThree.disabled = dis
