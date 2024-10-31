extends Control

@export var min_boxes = 2
@export var max_boxes = 10
@onready var slider = $ColorRect/MarginContainer/VBoxContainer/Object_Slider
@onready var generate_button = $ColorRect/MarginContainer/VBoxContainer/Random_List
@onready var start_sim_button = $ColorRect/MarginContainer/VBoxContainer/Start_Sim
@onready var list_text_edit = $ColorRect/MarginContainer/VBoxContainer/List

var boxes = []
var numbers = []
var num_boxes = min_boxes
var random_values = []
var randomize_on_start = false

func _ready():
	# Check if Globals.PickableObject is set
	if Globals.PickableObject == null:
		print("Error: Globals.PickableObject is not set. Please ensure it is assigned properly.")
		return
	
	slider.min_value = min_boxes
	slider.max_value = max_boxes
	slider.value = min_boxes
	slider.value_changed.connect(_on_slider_value_changed)
	generate_button.toggled.connect(_on_generate_button_toggled)
	start_sim_button.pressed.connect(_on_start_sim_pressed)
	
	Globals.PickableObject.visible = false


func _on_slider_value_changed(value: float):
	num_boxes = int(value)

func _on_generate_button_toggled(button_pressed: bool):
	randomize_on_start = button_pressed
	if randomize_on_start:
		_generate_random_values()
	else:
		random_values.clear()
	print("Random values set to:", random_values)

func _generate_random_values():
	random_values.clear()
	for i in range(num_boxes):
		random_values.append(int(randf() * 100))
	print("Generated random values:", random_values)

func _on_start_sim_pressed():
	# Generate random values or use user input
	if randomize_on_start:
		_generate_random_values()
		_generate_boxes(num_boxes, random_values)  # Pass random values for labeling
	else:
		_check_user_input()
		if _is_sorted(numbers):
			_generate_boxes(num_boxes, numbers)  # Use user values for labeling
	print("Starting Simulation...")


func _generate_boxes(num_boxes: int, values: Array = []):
	# Remove existing boxes
	for box in boxes:
		box.queue_free()
	boxes.clear()
	
	# Create new boxes based on the specified number
	for i in range(num_boxes):
		var box_instance = Globals.PickableObject.duplicate()  # Duplicate the global template
		box_instance.name = "Box_%d" % i
		box_instance.visible = true
		
		# Set position and add it to the scene
		box_instance.global_transform.origin = Vector3(i * 2, 0, 0)  # Spread out along the x-axis
		add_child(box_instance)
		boxes.append(box_instance)

		# Label the box with the corresponding value if available
		if i < values.size():
			box_instance.get_node("Label3D").text = str(values[i])


func _apply_random_values():
	# Apply stored random values to the boxes
	for i in range(num_boxes):
		if i < random_values.size():
			boxes[i].get_node("Label3D").text = str(random_values[i])

func _check_user_input():
	# Get user input from TextEdit and check if it's sorted
	var input_text = list_text_edit.text.strip_edges()  # Get the text and remove any whitespace
	if input_text == "":
		print("No input provided.")
		return

	# Remove trailing commas and split input by spaces
	var cleaned_input = input_text.strip_edges().replace(",", "").strip_edges()
	var user_values = cleaned_input.split(" ")  # Split input by spaces
	if user_values.size() != num_boxes:
		print("Input must contain exactly ", num_boxes, " values.")
		return

	numbers.clear()  # Clear previous numbers

	# Convert input to integers and handle errors
	for value in user_values:
		var trimmed_value = value.strip_edges()
		if trimmed_value.is_valid_int():
			numbers.append(int(trimmed_value))
		else:
			print("Invalid number in input:", trimmed_value)
			return

	# Check if numbers are in ascending order
	if _is_sorted(numbers):
		print("Input is sorted:", numbers)
	else:
		print("Input is not sorted. Values:", numbers)

func _is_sorted(arr: Array) -> bool:
	# Check if the array is sorted in ascending order
	for i in range(arr.size() - 1):
		if arr[i] > arr[i + 1]:
			return false
	return true
