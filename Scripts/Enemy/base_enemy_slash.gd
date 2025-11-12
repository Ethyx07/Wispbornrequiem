extends Sprite2D

#The base class for the enemy slashing attack

var parent : CharacterBody2D
var hit_player = []


func _on_attackbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !hit_player.has(body): #checks if actor hit is a player and if it has been added to the list of hit actors
		hit_player.append(body) #Prevents player who is hit on multiple hitboxes from taking extra damage
		parent.attack_hit(body) #Calls the parent of this slash attack function 
