extends "res://Scripts/Interactables/Interactables.gd"
@onready var menu = get_node("../CanvasLayer/itemMenu")
var upgradeData : Resource

func _ready() -> void:
	var randInt = randi_range(0, Gamemode.HydraLoot.size() - 1)
	upgradeData = load(Gamemode.HydraLoot[randInt])
	highlightedTexture = upgradeData.highlightIcon
	baseTexture = upgradeData.icon
	itemDesc = upgradeData.upgradeName + "\n" + upgradeData.upgradeDesc
	get_node("MainTexture").texture = upgradeData.icon
	
func interact(body : Node2D)->void:
	menu.get_node("Item").text = itemDesc
	menu.upgradeData = upgradeData
	menu.body = body
	menu.upgradeItem = self
	get_tree().get_first_node_in_group("Player").inputEnabled = false
	menu.show()
	
func highlighted() -> void:
	super()
	get_node("../CanvasLayer/playergui/itemDesc").clear()
