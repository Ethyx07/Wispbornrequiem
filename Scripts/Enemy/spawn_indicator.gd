extends Node2D

@onready var animPlayer = get_node("animPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Plays animation and disappears after 2.5 seconds (end of timer)
	await get_tree().create_timer(2.5).timeout
	self.queue_free()
