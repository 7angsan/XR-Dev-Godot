extends Button 

# Specify the path to the scene you want to load
@export var scene_path: String = "res://Demo/demomain.tscn"

# Called when the button is pressed
func _on_button_pressed():
	# Load the new scene as a PackedScene
	var new_scene = load(scene_path) as PackedScene
	
	# Change the scene if loading was successful
	if new_scene:
		get_tree().change_scene_to(new_scene)  # Use change_scene_to with the PackedScene
	else:
		push_error("Failed to load scene at path: " + scene_path)

# Called when the node is ready
func _ready():
	# Connect the button's pressed signal to the method correctly
	self.pressed.connect(_on_button_pressed)  # Connect signal to the button pressed event
