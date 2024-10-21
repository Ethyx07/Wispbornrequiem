extends CharacterBody2D

@export var speed : float = 20.0
@export var dashSpeed: float = 100

@onready var attackDirection = get_node("attackMarker")
@onready var playerSprite = get_node("playerSprite")
@onready var dashParticle : PackedScene = preload("res://Scenes/Particles/dash_particle.tscn")

var facingBody : Node2D
var bDashing : bool = false

func _physics_process(delta: float) -> void:
	if !bDashing:
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
	
func wait(delay : float)-> void:
	pass
