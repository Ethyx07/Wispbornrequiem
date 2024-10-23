extends Node





func load_level(level : PackedScene) -> void:
	get_tree().change_scene_to_file(level.resource_path)
	var player = PlayerData.playerScene.instantiate()
	get_tree().root.add_child(player)
	PlayerData.loadPlayerInfo(player)
	
