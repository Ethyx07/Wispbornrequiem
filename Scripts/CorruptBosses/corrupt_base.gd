extends CharacterBody2D

@export var bossName : String
@export var bossMaxHealth : int
@export var bossKey : String
@export var speed : int

@onready var animPlayer = get_node("animPlayer")
@onready var nav_agent = get_node("NavAgent")

var targetPlayer : CharacterBody2D
var currentHealth
var arenaNode

enum bossState {CHASE, ATTACK, DEAD}
var currentState : bossState

func _ready() -> void:
	currentHealth = bossMaxHealth
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 40
	currentState = bossState.CHASE

func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer) and currentState == bossState.CHASE:
		get_node("hitbox").look_at(targetPlayer.global_position)
		if nav_agent.distance_to_target() > nav_agent.target_desired_distance:
			nav_agent.target_position = targetPlayer.global_position
			await get_tree().physics_frame
			var direction = self.global_position.direction_to(nav_agent.get_next_path_position())
			velocity = direction * delta * speed
			if position.distance_to(targetPlayer.global_position) <= 90:
				var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
				velocity += seperationVector
				attack()
			#if direction.x < 0:
				#self.flip_h = true
			#else:
				#self.flip_h = false
			move_and_slide()
		else:
			move_and_slide()
	else:
		var targetArray = get_tree().get_nodes_in_group("Player")
		targetPlayer = targetArray[0]
	
	
func hit(damage : float)-> void:
	currentHealth -= damage
	if currentHealth <= 0:
		currentState = bossState.DEAD
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
	
func attack() -> void:
	var attackRand = randi_range(0,2)
	match attackRand:
		0:
			print("ice")
		1:
			print("fire")
		2:
			print("poison")
