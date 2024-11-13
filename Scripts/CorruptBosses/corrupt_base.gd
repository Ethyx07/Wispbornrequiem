extends CharacterBody2D

@export var bossName : String
@export var bossMaxHealth : int
@export var bossKey : String

@onready var animPlayer = get_node("animPlayer")

var currentHealth
var arenaNode


func _ready() -> void:
	currentHealth = bossMaxHealth

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	pass
	
	
func hit(damage : float)-> void:
	currentHealth -= damage
	if currentHealth <= 0:
		currentHealth = 0
		arenaNode.updateUI()
		animPlayer.play("deathAnim")
		await animPlayer.animation_finished
		get_node("hurtbox").disabled = true
		Gamemode.activePodiums[bossKey] = true
		get_tree().change_scene_to_file("res://Scenes/hub_scene.tscn")
	else:
		arenaNode.updateUI()
	
	
