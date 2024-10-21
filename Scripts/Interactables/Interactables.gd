extends Node

@export var itemDesc: String
@export var highlightedTexture : Texture2D
@export var baseTexture : Texture2D



func interact(body: Node2D) -> void:
	print(itemDesc)
	
	
func highlighted() -> void:
	get_node("MainTexture").texture = highlightedTexture
	
func unhighlighted() -> void:
	get_node("MainTexture").texture = baseTexture
