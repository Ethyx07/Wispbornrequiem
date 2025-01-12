extends Control

@export var wispTextures : Array[Texture2D]
@export var minotaurTextures : Array[Texture2D]
@export var hydraTextures : Array[Texture2D]

@export var spriteList : Array[Sprite2D] #Stores the non-wisp sprites (same order as the dictionaries

@onready var textureDict = {"Wisp" : wispTextures,
"Minotaur" : minotaurTextures,
"Hydra" : hydraTextures}

func _ready() -> void:
	pass

func updateSprites(save : bool) -> void:
	if save:
		get_node("wisp/wisp").texture = wispTextures[1]
		for sprites in Gamemode.activePodiums:
			var tempArray = textureDict[sprites]
			if Gamemode.activePodiums[sprites]:
				for sprite in spriteList:
					if sprite.name == sprites:
						sprite.texture = tempArray[1]
			else:
				for sprite in spriteList:
					if sprite.name == sprites:
						sprite.texture = tempArray[0]
	else:
		get_node("wisp/wisp").texture = wispTextures[0]
		for sprites in Gamemode.activePodiums:
			var tempArray = textureDict[sprites]
			for sprite in spriteList:
					if sprite.name == sprites:
						sprite.texture = tempArray[0]
