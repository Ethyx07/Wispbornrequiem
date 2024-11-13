extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var podiums = get_tree().get_nodes_in_group("Podium")
	for podium in podiums:
		podium.bUnlocked = Gamemode.activePodiums[podium.podiumKey]
		podium.setStatus()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
