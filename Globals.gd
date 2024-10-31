# Globals.gd
extends Node

# Load the main scene and declare the global PickableObject variable
const MAIN = preload("res://main.tscn")
var PickableObject  # This will be set to the PickableObject node

func _ready():
	# Instantiate MAIN and retrieve the PickableObject node
	var main_instance = MAIN.instantiate()
	PickableObject = main_instance.get_node("PickableObject")
	PickableObject.visible = false  # Hide the template initially
