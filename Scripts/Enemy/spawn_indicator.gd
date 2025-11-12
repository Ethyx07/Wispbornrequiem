extends Node2D

@onready var animPlayer = get_node("animPlayer")

#Creates spawner indicator that shows where and when the enemy will spawn

func _ready() -> void: #Plays animation and disappears after 2.5 seconds (end of timer)
	await get_tree().create_timer(2.5).timeout
	self.queue_free()
