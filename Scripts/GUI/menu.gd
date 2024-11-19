extends Control

@onready var saveMenu = get_node("saveMenu")
@onready var mainMenu = get_node("mainMenu")
@onready var loadButtons = get_node("loadDelete")
@onready var saveOne = get_node("saveMenu/saveOne")
@onready var saveTwo = get_node("saveMenu/saveTwo")
@onready var saveThree = get_node("saveMenu/saveThree")
var selectedSave : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var styleBoxOne = StyleBoxFlat.new() # Replace with function body.
	var styleBoxTwo = StyleBoxFlat.new()
	var styleBoxThree = StyleBoxFlat.new()
	
	saveOne.add_theme_stylebox_override("normal", styleBoxOne)
	saveTwo.add_theme_stylebox_override("normal", styleBoxTwo)
	saveThree.add_theme_stylebox_override("normal", styleBoxThree)
	
func _on_play_button_pressed() -> void:
	mainMenu.hide()
	print("done")
	saveMenu.show()
	loadButtons.show()


func _on_save_one_pressed() -> void:
	selectedSave = 1
	saveOne.get_theme_stylebox("normal").bg_color = Color.GREEN
	saveTwo.get_theme_stylebox("normal").bg_color = Color.GRAY
	saveThree.get_theme_stylebox("normal").bg_color = Color.GRAY

func _on_save_two_pressed() -> void:
	selectedSave = 2
	saveOne.get_theme_stylebox("normal").bg_color = Color.GRAY
	saveTwo.get_theme_stylebox("normal").bg_color = Color.GREEN
	saveThree.get_theme_stylebox("normal").bg_color = Color.GRAY

func _on_save_three_pressed() -> void:
	selectedSave = 3 
	saveOne.get_theme_stylebox("normal").bg_color = Color.GRAY
	saveTwo.get_theme_stylebox("normal").bg_color = Color.GRAY
	saveThree.get_theme_stylebox("normal").bg_color = Color.GREEN

func _on_load_save_pressed() -> void:
	loadGame(selectedSave)

func _on_delete_save_pressed() -> void:
	SaveLogic.delete_save(selectedSave) # Replace with function body.

func loadGame(slot : int) -> void:
	SaveLogic.load_game(slot)
	Gamemode.saveSlot = slot
	openHub()

func openHub() -> void:
	get_tree().change_scene_to_file("res://Scenes/hub_scene.tscn")


# Replace with function body.
