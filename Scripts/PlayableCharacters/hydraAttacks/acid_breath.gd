extends Node2D

@onready var animPlayer = get_node("animPlayer")
var breathDamage : int
var poisonDamage : int
var poisonTick : int
var parent : CharacterBody2D
var targetGroup : String

var hitBody : Array[CharacterBody2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await animPlayer.animation_finished
	self.queue_free()

func _physics_process(_delta: float) -> void:
	self.global_position = parent.get_node("attackMarker/attackDirection").global_position
	self.look_at(get_global_mouse_position())

func _on_collision_area_body_entered(body: Node2D) -> void:
	if body != parent and body.is_in_group(targetGroup) and !hitBody.has(body):
		hitBody.append(body)
		if !body.is_in_group("Boss") and !body.is_in_group("Player"):
			body.poisonTickDamage = poisonDamage
			body.poisonTick = poisonTick
			body.statusEffect = body.statusState.POISON
			body.checkStatus()
		body.hit(breathDamage)
