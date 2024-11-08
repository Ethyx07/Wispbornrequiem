extends CharacterBody2D

var targetPlayer : CharacterBody2D
var bKnockedback : bool = false
@export var speed : float = 200
@export var health : int = 10
@export var attackDelay : float = 0.2
@export var damage: int = 2

enum enemyState {CHASE, ATTACK, DEAD, HIT}
var currentState : enemyState

@onready var sprite : Sprite2D = get_node("mainTexture")
@onready var attackSlash : PackedScene = preload("res://Scenes/Enemies/base_enemy_slash.tscn")
@onready var hp_bar = get_node("hp_bar")
@onready var nav_agent = get_node("NavAgent")

func _ready() -> void:
	var targetArray = get_tree().get_nodes_in_group("Player")
	targetPlayer = targetArray[0]
	get_node("hitbox/attackbox").disabled = true
	hp_bar.max_value = health
	hp_bar.value = health
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 50.0



func _physics_process(delta: float) -> void:
	if is_instance_valid(targetPlayer) and currentState == enemyState.CHASE:
		get_node("hitbox").look_at(targetPlayer.global_position)
		if !bKnockedback and nav_agent.distance_to_target() > nav_agent.target_desired_distance:
			nav_agent.target_position = targetPlayer.global_position
			await get_tree().physics_frame
			var direction = self.global_position.direction_to(nav_agent.get_next_path_position())
			velocity = direction * delta * speed
			if position.distance_to(targetPlayer.global_position) < 80:
				var seperationVector = (global_position - targetPlayer.global_position).normalized() * 25
				velocity += seperationVector
				attack()
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			move_and_slide()
		else:
			move_and_slide()
	else:
		var targetArray = get_tree().get_nodes_in_group("Player")
		targetPlayer = targetArray[0]
		
func hit(damageDealt : int) -> void:
	health -= damageDealt
	hp_bar.value = health
	if health <= 0:
		currentState = enemyState.DEAD
		hp_bar.visible = false
		self.collision_layer = 0
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		self.queue_free()
	currentState = enemyState.HIT
	await get_tree().create_timer(0.2).timeout
	currentState = enemyState.CHASE
		
func knockback(knockbackVector : Vector2) -> void:
	var knockbackForce = knockbackVector.normalized()
	velocity = knockbackForce * 50
	bKnockedback = true
	await get_tree().create_timer(5).timeout
	bKnockedback = false
	
func attack():
	if currentState != enemyState.ATTACK:
		currentState = enemyState.ATTACK
		await get_tree().create_timer(attackDelay).timeout
		get_node("hitbox/attackbox").disabled = false
		var slashTemp = attackSlash.instantiate()
		slashTemp.parent = self
		add_child(slashTemp)
		slashTemp.global_position = get_node("hitbox/attackbox").global_position
		slashTemp.look_at(get_global_mouse_position())
		slashTemp.get_node("animPlayer").play("attack_slash")
		await slashTemp.get_node("animPlayer").animation_finished
		get_node("hitbox/attackbox").disabled = true
		slashTemp.queue_free()
		await get_tree().create_timer(1).timeout
		currentState = enemyState.CHASE
	else:
		return

func attack_hit(body : Node2D) -> void:
	body.hit(damage)

#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#body.hit(damage) 
		#print(body.health)
