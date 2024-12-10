extends Control

var upgradeData : Resource
var upgradeItem : Node2D
var body : Node2D
var itemNum : int

func _on_accept_pressed() -> void:
	body.applyUpgrade(upgradeData.bonusType, upgradeData.effectBonus)
	self.hide()
	get_tree().get_first_node_in_group("Player").inputEnabled = true
	#Gamemode.runtimeLootTable.remove_at(itemNum)
	upgradeItem.queue_free()

func _on_decline_pressed() -> void:
	self.hide()
	get_tree().get_first_node_in_group("Player").inputEnabled = true # Replace with function body.
