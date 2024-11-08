extends CharacterBody2D

@export var speed : float = 20.0
@export var dashSpeed: float = 100
@export var dashCooldown : float = 4

@export var attackDamage : float
@export var attackCooldown: float
@export var specialDamage : float
@export var specialCooldown: float = 5
@export var health : float
@export var maxHealth : float

enum playerState {NEUTRAL, ATTACK, DEAD, DASH}
@export var currentState : playerState
var bUlting : bool = false


@export var sceneKey : String

@onready var hurtbox = get_node("hurtbox")
@onready var attackDirection = get_node("attackMarker")
@onready var playerSprite = get_node("playerSprite")
@onready var dashParticle : PackedScene = preload("res://Scenes/Particles/dash_particle.tscn")

var facingBody : Node2D
var bCanUseSpecial = true
var lastState

func _physics_process(_delta: float) -> void:
	match currentState:
		playerState.DEAD:
			return
		_:
			var inputVector = Vector2.ZERO
			inputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
			inputVector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
			if inputVector.x < 0:
				#faces to the left
				playerSprite.flip_h = true
				get_node("InteractableBox/interact_box_left").disabled = false
				get_node("InteractableBox/interact_box_right").disabled = true
			elif inputVector.x > 0:
				#faces to the right
				playerSprite.flip_h = false
				get_node("InteractableBox/interact_box_left").disabled = true
				get_node("InteractableBox/interact_box_right").disabled = false
			velocity = inputVector * speed
			move_and_slide()
	
		#Moves attack direction
			if is_instance_valid(attackDirection):
				attackDirection.look_at(get_global_mouse_position())
		
			if Input.is_action_just_pressed("Interact"):
				if is_instance_valid(facingBody):
					facingBody.interact(get_node("."))
		#Dash mechanic and spawning of 2 smoke bomb particle effects at each dash point
	lastState = currentState

func _on_interactable_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Interactable") and !is_instance_valid(facingBody):
		facingBody = body
		facingBody.highlighted()

func _on_interactable_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Interactable") and is_instance_valid(facingBody):
		facingBody.unhighlighted()
		facingBody = null

func _on_particle_finished(particleInstance : Node)-> void:
	particleInstance.queue_free()
	
func dash()-> Vector2:
	#Creates particle where the player leaves from
		currentState = playerState.DASH
		return (get_global_mouse_position() - self.global_position).normalized()

	
func attack() -> void:
	pass
	
func attack_hit(body : Node2D) ->void:
	body.hit(attackDamage)
	
func special_hit(body : Node2D) -> void:
	body.hit(specialDamage)
	
func hit(damage : int) -> void:
	health -= damage
	
func ultActivate() ->void:
	bUlting = true
	
func pitCheck()->void:
	if lastState == playerState.DASH and currentState == playerState.NEUTRAL:
		print("Working")
		
