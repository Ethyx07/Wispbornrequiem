extends Node2D
class_name WorldScene


# Called when the node enters the scene tree for the first time.
func loadNextLevel() ->void:
	print(get_node("/root/World"))
