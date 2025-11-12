extends CharacterBody2D

#Base class for the enemy, for movement and attacks


var targetPlayer : CharacterBody2D
var bKnockedback : bool = false
@export var speed : float = 200
@export var health : int = 10
@export var attackDelay : float = 0.2
@export var damage: int = 2

enum enemyState {CHASE, ATTACK, DEAD, HIT}
var currentState : enemyState

enum statusState {NONE, POISON, STUN, SLOW, CHARM}
var statusEffect : statusState
var poisonTick : int
var poisonTickDamage : int
var currentTick = 0

@onready var sprite : Sprite2D = get_node("mainTexture")
@onready var attackSlash : PackedScene = preload("res://Scenes/Enemies/base_enemy_slash.tscn")
@onready var hp_bar = get_node("hp_bar")
@onready var nav_agent = get_node("NavAgent")
@onready var statusBar = get_node("hp_bar/statusBar")

func _ready() -> void: 
	var targetArray = get_tree().get_nodes_in_group("Player") #Gets array of all players
	targetPlayer = targetArray[0] #Currently sets target player as 0, in future/co-op will use closest player as target
	get_node("hitbox/attackbox").disabled = true #Disables attack hitbox which detects players within it and deals damage according
	hp_bar.max_value = health
	hp_bar.value = health
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 50.0
	statusEffect = statusState.NONE



func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer) and currentState == enemyState.CHASE and statusEffect != statusState.STUN: #Makes sure there is a possible target player, that the enemy is chasing and that they arent currently stunned
		get_node("hitbox").look_at(targetPlayer.global_position) #Hitbox always faces towards the player, rotates around the enemy actor
		if !bKnockedback and nav_agent.distance_to_target() > nav_agent.target_desired_distance:
			nav_agent.target_position = targetPlayer.global_position #Navigation agent sets a new target position as the players current pos
			await get_tree().physics_frame
			var direction = self.global_position.direction_to(nav_agent.get_next_path_position())
			velocity = direction * delta * speed #Creates straight line direction vector from enemy to player
			if position.distance_to(targetPlayer.global_position) < 80: #Keeps the enemy from bumping into the player by keeping a range offset
				var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
				velocity += seperationVector
				attack() #Attack action
			if direction.x < 0: #Flips direction of sprite based on its x velocity
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			move_and_slide()
		else:
			move_and_slide()
	else: #If player is not set it finds and sets it
		var targetArray = get_tree().get_nodes_in_group("Player")
		targetPlayer = targetArray[0]
		
func hit(damageDealt : int) -> void:
	health -= damageDealt #Deals damage to enemy from the player
	hp_bar.value = health #Updates hp value (Progress bar) above enemy head
	if health <= 0:
		currentState = enemyState.DEAD #Changes state to dead to stop the enemy from continuing its logic
		hp_bar.visible = false
		self.collision_layer = 0
		get_node("AnimationPlayer").play("death") #Plays death animation when killed
		await get_node("AnimationPlayer").animation_finished #Waits for animation to complete before removing it
		self.queue_free()
	currentState = enemyState.HIT
	await get_tree().create_timer(0.2).timeout #Stuns enemy for 0.2 seconds
	currentState = enemyState.CHASE
		
func knockback(knockbackVector : Vector2) -> void:
	var knockbackForce = knockbackVector.normalized()
	velocity = knockbackForce * 50 #Vector is from the player position in the direction of the enemy and is multiplied by 50
	bKnockedback = true
	await get_tree().create_timer(5).timeout
	bKnockedback = false
	
func attack():
	if currentState != enemyState.ATTACK: #Enemy cannot attack if currently attacking
		currentState = enemyState.ATTACK
		await get_tree().create_timer(attackDelay).timeout 
		get_node("hitbox/attackbox").disabled = false #Disables it after attack delay/charge ends
		var slashTemp = attackSlash.instantiate() #Creates slash in scene
		slashTemp.parent = self
		add_child(slashTemp)
		slashTemp.global_position = get_node("hitbox/attackbox").global_position
		slashTemp.look_at(get_global_mouse_position())
		slashTemp.get_node("animPlayer").play("attack_slash")
		await slashTemp.get_node("animPlayer").animation_finished
		get_node("hitbox/attackbox").disabled = true
		slashTemp.queue_free()
		await get_tree().create_timer(1).timeout
		currentState = enemyState.CHASE #After attacking delay 1s from continued actions
	else:
		return

func attack_hit(body : Node2D) -> void:
	body.hit(damage) #Calls the hit actors hit function

func checkStatus() -> void:
	match statusEffect: #Checks status effect that is on the enemy
		statusState.POISON:
			dealPoisonDamage() #If poisoned, poison function called
		statusState.STUN:
			stunLogic() #Calls stun logic if enemy became stunned
	statusBar.updateStatusUI(self) #Updates the UI of the enemy to show what status effect it has
			
func dealPoisonDamage() -> void:
	if currentTick < poisonTick:
		currentTick += 1 #Poison damage occurs over time with a chance for early curing
		hit(poisonTickDamage)
		var randCure = randi_range(0, 10)
		if randCure >= 10:
			statusEffect = statusState.CHARM #Temporary using charm effect to show they have healed
		await get_tree().create_timer(1).timeout
	else:
		statusEffect = statusState.CHARM
	checkStatus()

func stunLogic() -> void: #Enemy becomes stunned for 2s before returning to normal
	await get_tree().create_timer(2).timeout
	statusEffect = statusState.NONE
	checkStatus()

func remove_self() ->void:
	self.queue_free() #Destroys actor when function called

#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#body.hit(damage) 
		#print(body.health)
