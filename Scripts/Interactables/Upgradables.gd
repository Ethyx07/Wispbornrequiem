extends "res://Scripts/Interactables/Interactables.gd"
@onready var menu = get_node("../CanvasLayer/itemMenu")
var upgradeData : Resource
var randInt

func _ready() -> void:
	randInt = randi_range(0, Gamemode.runtimeLootTable.size() - 1)
	upgradeData = load(Gamemode.runtimeLootTable[randInt])
	highlightedTexture = upgradeData.highlightIcon
	baseTexture = upgradeData.icon
	itemDesc = upgradeData.upgradeName + "\n" + upgradeData.upgradeDesc
	get_node("MainTexture").texture = upgradeData.icon
	
func interact(body : Node2D)->void:
	menu.itemNum = randInt
	menu.get_node("Item").text = itemDesc
	menu.upgradeData = upgradeData
	menu.body = body
	menu.upgradeItem = self
	get_tree().get_first_node_in_group("Player").inputEnabled = false
	menu.show()
	
func highlighted() -> void:
	super()
	get_node("../CanvasLayer/playergui/itemDesc").clear()
