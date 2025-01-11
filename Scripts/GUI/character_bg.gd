extends Control

@export var wispTextures : Array[Texture2D]
@export var minotaurTextures : Array[Texture2D]
@export var hydraTextures : Array[Texture2D]

@export var spriteList : Array[Sprite2D] #Stores the non-wisp sprites (same order as the dictionaries

@onready var textureDict = {"Wisp" : wispTextures,
"Minotaur" : minotaurTextures,
"Hydra" : hydraTextures}

func _ready() -> void:
	updateSprites(false)

func updateSprites(bEmpty : bool) -> void:
	if !bEmpty:
		get_node("wisp/wisp").texture = wispTextures[1]
	else:
		get_node("wisp/wisp").texture = wispTextures[0]
	var index = 0
	for sprites in Gamemode.activePodiums:
		var tempArray = textureDict[sprites]
		if Gamemode.activePodiums[sprites]:
			spriteList[index].texture = tempArray[1]
		else:
			spriteList[index].texture = tempArray[0]
		index += 1
