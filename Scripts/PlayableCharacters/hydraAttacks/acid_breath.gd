extends Node2D

@onready var animPlayer = get_node("animPlayer")
var breathDamage : int
var poisonDamage : int
var poisonTick : int
var parent : CharacterBody2D
var targetGroup : String

var bHitPlayer : bool = false

var hitBody : Array[CharacterBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await animPlayer.animation_finished
	self.queue_free()

func _physics_process(_delta: float) -> void:
	if targetGroup == "Player":
		if animPlayer.is_playing() and parent.currentState == parent.bossState.DEAD:
			animPlayer.stop()
		if is_instance_valid(parent):
			self.global_position = parent.get_node("hitbox/attackDirection").global_position
			self.rotation = parent.get_node("hitbox").rotation
		else:
			self.queue_free()
	else:
		self.global_position = parent.get_node("attackMarker/attackDirection").global_position
		if parent.currentDevice == parent.controllerState.KBM:
			self.look_at(get_global_mouse_position())
		else:
			self.rotation = parent.get_node("attackMarker").rotation
	

func _on_collision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !bHitPlayer and body != parent:
		bHitPlayer = true
		body.hit(breathDamage)
		return
	if body != parent and body.is_in_group(targetGroup) and !hitBody.has(body):
		hitBody.append(body)
		if !body.is_in_group("Boss") and !body.is_in_group("Player"):
			body.poisonTickDamage = poisonDamage
			body.poisonTick = poisonTick
			body.statusEffect = body.statusState.POISON
			body.checkStatus()
		body.hit(breathDamage)
	if body.is_in_group("Projectile"):
		print("hit")
