extends Node

@export var itemDesc: String
@export var highlightedTexture : Texture2D
@export var baseTexture : Texture2D



func interact(body: Node2D) -> void:
	print(itemDesc)
	
	
func highlighted() -> void:
	get_node("MainTexture").texture = highlightedTexture
	get_node("../CanvasLayer/playergui").get_child(0).clear()
	get_node("../CanvasLayer/playergui").get_child(0).add_text(itemDesc)
	
func unhighlighted() -> void:
	get_node("MainTexture").texture = baseTexture
	get_node("../CanvasLayer/playergui").get_child(0).clear()
