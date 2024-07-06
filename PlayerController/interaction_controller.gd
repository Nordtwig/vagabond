extends RayCast3D


@onready var _interact_prompt_label: Label = get_node("InteractionPrompt")

func _process(delta) -> void:
	var object = get_collider()
	_interact_prompt_label.text = ""

	if object and object is InteractableObject:
		if !object.can_interact_with:
			return
		
		_interact_prompt_label.text = "[E] " + object.interact_prompt

		if Input.is_action_just_pressed("interact"):
			object.interact()

	
