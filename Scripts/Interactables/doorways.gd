extends "res://Scripts/Interactables/Interactables.gd"

@export var lockedTexture : Texture2D
@onready var animator = get_node("animPlayer")
@export var bIsUnlocked : bool = false
@export var bHubDoor : bool = false
@export var bBossDoor : bool = false
@export var nextAreaKey : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !bIsUnlocked:
		get_node("MainTexture").texture = lockedTexture
	else:
		get_node("MainTexture").texture = baseTexture



func interact(body: Node2D)-> void:
	if bIsUnlocked:
		super(body)
		if bHubDoor:  #Populates table and generates the level for the first dungeon
			Gamemode.populateLootTable(body.sceneKey)
			Gamemode.levelGenerator()
		elif bBossDoor: #Generates next area, changes key for level dict to new area and resets currentLevel counter
			Gamemode.area_key = nextAreaKey
			Gamemode.currentLevel = 0
			Gamemode.levelGenerator()
		PlayerData.savePlayerInfo(body.sceneKey, body)
		Gamemode.load_level()
		body.queue_free()
		
		
func highlighted()-> void:
	if bIsUnlocked:
		super()
		
func unhighlighted()-> void:
	if bIsUnlocked:
		super()
	
