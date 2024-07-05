class_name InteractableObject
extends Node3D

@export var interact_prompt: String
@export var can_interact_with: bool = true


func interact():
	print("Override this function")