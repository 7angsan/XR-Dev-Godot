extends HSlider

# Define a custom signal to send the slider value
signal value_changed_signal(value: float)

# Array to store references to the Option nodes
var options: Array = []

# Called when the node enters the scene tree for the first time
func _ready():
	print("Slider initialized with value:", value)

	# Load the DemoCube scene
	var demo_cube_scene = load("res://Demo/Boxes/DemoCube.tscn")
	var demo_cube_instance = demo_cube_scene.instantiate()
	add_child(demo_cube_instance)  # Add it to the current scene

	# Access Option nodes directly from the instantiated DemoCube
	for i in range(2, 7):  # 2 to 6
		var option_node = demo_cube_instance.get_node("Option" + str(i))
		if option_node:
			options.append(option_node)
			option_node.visible = false  # Hide initially
		else:
			print("Option", i, "not found!")

	# Connect the built-in value_changed signal to a custom method
	connect("value_changed", Callable(self, "_on_value_changed"))

	# Emit the signal for the initial value to ensure it's received
	emit_signal("value_changed_signal", value)

# Custom method to handle the slider value change
func _on_value_changed(new_value: float):
	print("Slider value changed to:", new_value)
	emit_signal("value_changed_signal", new_value)  # Emit the signal with the new value
	call_deferred("_update_visibility", new_value)  # Defer the visibility update to next frame

# Deferred function to update the visibility of the options based on the slider value
func _update_visibility(value: float):
	print("Updating visibility for value:", value)

	# Hide all options first
	for option in options:
		option.visible = false

	# Show the selected option (based on slider value)
	var option_index = int(value)
	if option_index >= 2 and option_index <= 6:
		var selected_option = options[option_index - 2]  # Adjust index for array
		selected_option.visible = true
		print("Option", option_index, "is now visible.")
