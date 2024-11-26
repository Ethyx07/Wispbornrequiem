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
enum controllerState {KBM, Controller}

var currentDevice = controllerState.KBM
@export var currentState : playerState
var bUlting : bool = false
var attackInput

@export var sceneKey : String

@onready var hurtbox = get_node("hurtbox")
@onready var attackDirection = get_node("attackMarker")
@onready var playerSprite = get_node("playerSprite")
@onready var dashParticle : PackedScene = preload("res://Scenes/Particles/dash_particle.tscn")

var facingBody : Node2D
var bCanUseSpecial = true
var lastState
var inputVector

var shakeStrength : float = 0
var randShake : float = 15
var shakeFade : float = 5
var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	match currentState:
		playerState.DEAD:
			return
		_:
			if currentDevice == controllerState.KBM:
				inputVector = Vector2.ZERO
				inputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
				inputVector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
			else:
				inputVector = Input.get_vector("Left", "Right", "Up", "Down")
			
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
				attackInput = Vector2( Input.get_action_strength("aimRight") - Input.get_action_strength("aimLeft"),
				Input.get_action_strength("aimDown") - Input.get_action_strength("aimUp"))
				if currentDevice == controllerState.Controller and attackInput.length() > 0.1:
					attackDirection.rotation = attackInput.angle()
				elif currentDevice == controllerState.KBM:
					attackDirection.look_at(get_global_mouse_position())
		
			if Input.is_action_just_pressed("Interact"):
				if is_instance_valid(facingBody):
					facingBody.interact(get_node("."))
			if shakeStrength > 0:
				shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
				get_node("Camera2D").offset = Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
				
	lastState = currentState

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		currentDevice = controllerState.KBM
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		currentDevice = controllerState.Controller
		

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
		if currentDevice == controllerState.KBM:	
			return (get_global_mouse_position() - self.global_position).normalized()
		return (get_node("attackMarker/attackDirection").global_position - self.global_position).normalized()

	
func attack() -> void:
	pass
	
func attack_hit(body : Node2D) ->void:
	body.hit(attackDamage)
	
func special_hit(body : Node2D) -> void:
	body.hit(specialDamage)
	
func hit(damage : int) -> void:
	health -= damage
	if currentDevice == controllerState.Controller:
		var joypads = Input.get_connected_joypads()
		if joypads.size() > 0:
			var joypadIndex = joypads[0]
			Input.start_joy_vibration(joypadIndex, 1, 1, 0.25)
	if health <= 0: 
		health = 0
		Gamemode.respawn()
	
func ultActivate() ->void:
	bUlting = true
	
func pitCheck()->void:
	if lastState == playerState.DASH and currentState == playerState.NEUTRAL:
		print("Working")
	
func shakeScreen():
	shakeStrength = randShake
	
func remove_self() -> void:
	self.queue_free()
		
