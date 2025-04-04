extends Node3D

# Nodes for handling the scene structure
var label_3d: Label3D  # Global reference to Label3D
var timer: Timer
var option6: Node3D

# Narration lines
var narration_lines: Array = [
	"Welcome to the demo of the selection sort module.",
	"25 compares itself to the rest and plans to\n swap with 3 because that's the smallest number.",
	"They are now swapped.",
	"34 compares itself to everything on the right\n and finds 22 as the smallest.",
	"22 is now in the right position.",
	"25 compares itself and finds out\n that it is the smallest.",
	"25 doesn't move.",
	"81 compares itself and plans to swap with 34.",
	"34 is now in the correct spot.",
	"81 compares itself again with 56,\n which is smaller than 81.",
	"56 is now in the correct spot.",
	"81 compares itself with itself.",
	"81 doesn't move."
]

# Corresponding times for each narration line (in seconds)
var narration_times: Array = [
	5.0,  # 5 seconds for the first line
	3.0,  # 4 seconds for the second line
	3.0,  # 3 seconds for the third line
	3.0,  # 4.5 seconds for the fifth line
	3.0,  # 4 seconds for the sixth line
	3.0,  # 3 seconds for the eighth line
	3.0,  # 2.5 seconds for the ninth line
	3.0,  # 5 seconds for the tenth line
	3.0,  # 4 seconds for the eleventh line
	3.0,  # 3 seconds for the twelfth line
	3.0,  # 2 seconds for the thirteenth line
	3.0,   # 4 seconds for the fourteenth line
	3.0   # 4 seconds for the fourteenth line
]

# This will be the index of the current narration line
var index: int = 0

func _ready():
	print("skib!")

	# Assuming the Label3D is under the MeshInstance3D under Option6
	var mesh_instance = get_node("MeshInstance3D")  # Replace with the actual path to the MeshInstance3D
	if mesh_instance:
		label_3d = mesh_instance.get_node("Label3D")  # Assign to the global label_3d
		if label_3d:
			# Now you can modify label_3d.text or use it as needed
			print("Label3D found:", label_3d)
		else:
			print("Error: Label3D not found under MeshInstance3D!")
	else:
		print("Error: MeshInstance3D not found!")

	# Set up the timer
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true  # Ensure it only fires once
	timer.connect("timeout", Callable(self, "_on_timeout"))

	# Start with the first narration line
	_display_narration_line()

	# Start the timer with the first line's time
	timer.start(narration_times[index])

# Function to display the next narration line
func _on_timeout():
	if index < narration_lines.size() - 1:
		index += 1  # Increment index first
		_display_narration_line()  # Then display the next narration line
		timer.start(narration_times[index])  # Restart the timer with the next line's time
	else:
		print("Demo complete!")

# Function to display the narration line on the Label3D
func _display_narration_line():
	if label_3d:
		label_3d.text = narration_lines[index]
		print("Displaying narration:", narration_lines[index])
	else:
		print("Error: Label3D not found!")
