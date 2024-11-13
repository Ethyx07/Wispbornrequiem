extends "res://Scripts/PlayableCharacters/player_wisp.gd"

@onready var leftHeadSprite = get_node("playerSprite/leftHead")
@onready var middleHeadSprite = get_node("playerSprite/middleHead")
@onready var rightHeadSprite = get_node("playerSprite/rightHead")


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		if inputVector.x >= 0:
			playerSprite.flip_h = true
			leftHeadSprite.flip_h = true
			middleHeadSprite.flip_h = true
			rightHeadSprite.flip_h = true
		else:
			playerSprite.flip_h = false
			leftHeadSprite.flip_h = false
			middleHeadSprite.flip_h = false
			rightHeadSprite.flip_h = false
		
func _ready() -> void:
	inputVector = Vector2.ZERO
