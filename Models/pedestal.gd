extends InteractableObject

@onready var light_bulb: Node3D = get_node("LightBulb")


func interact() -> void:
	light_bulb.visible = true
	can_interact_with = false