extends Node

@export var itemDesc: String
@export var highlightedTexture : Texture2D
@export var baseTexture : Texture2D



func interact(_body: Node2D) -> void:
	pass
	
	
func highlighted() -> void:
	get_node("MainTexture").texture = highlightedTexture
	get_node("../CanvasLayer/playergui/itemDesc").clear()
	get_node("../CanvasLayer/playergui/itemDesc").add_text(itemDesc)
	
func unhighlighted() -> void:
	get_node("MainTexture").texture = baseTexture
	get_node("../CanvasLayer/playergui").get_child(0).clear()
