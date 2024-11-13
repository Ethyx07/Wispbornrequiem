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
		await get_tree().create_timer(5).timeout
		self.remove_from_group("Enemy")
	else:
		arenaNode.updateUI()
	
	
