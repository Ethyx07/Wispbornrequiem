extends "res://Scripts/CorruptBosses/corrupt_base.gd"

@export var arrow : PackedScene
var target

func hit(damage : float)-> void:
	super(damage)
	
func _ready() -> void:
	super()
	target = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(5).timeout
	spawnArrow()
	
func spawnArrow() -> void:
	var arrowTemp = arrow.instantiate()
	arrowTemp.global_position = get_node("hitbox/attackDirection").global_position
	arrowTemp.look_at(target.global_position)
	arrowTemp.targetGroup = "Player"
	arrowTemp.parent = self
	arrowTemp.arrowType = arrowTemp.arrowState.TRACK
	get_tree().root.add_child(arrowTemp)
	await get_tree().create_timer(5).timeout
	spawnArrow()


func _physics_process(delta: float) -> void:
	super(delta)
	get_node("hitbox").look_at(target.global_position)
