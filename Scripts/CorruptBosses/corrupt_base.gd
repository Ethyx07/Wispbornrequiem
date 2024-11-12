extends CharacterBody2D

@export var bossName : String
@export var bossMaxHealth : int

var currentHealth
var arenaNode

func _ready() -> void:
	currentHealth = bossMaxHealth

func _physics_process(delta: float) -> void:
	# Add the gravity.
	pass
	
	
func hit(damage : float)-> void:
	currentHealth -= damage
	arenaNode.updateUI()
	
