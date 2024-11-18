extends Node3D

# Variable to hold the loaded scene and HSlider reference
var slider_scene: PackedScene
var slider: HSlider
var debounce_timer: Timer  # Reference for the debounce timer

func _ready():
	print("DemoCube initialized.")
	
	# Load the slider scene from res://
	var slider_scene = load("res://Demo/DemoUI.tscn")  # Ensure this path is correct
	
	if not slider_scene:
		print("Failed to load scene!")
		return
	
	# Instantiate the slider scene
	var slider_instance = slider_scene.instantiate()
	if not slider_instance:
		print("Failed to instantiate slider scene!")
		return
	
	# Optionally add the slider to the scene tree if it should appear in-game
	get_tree().get_root().add_child(slider_instance)
	
	# Loop through all the children to find the HSlider
	for child in slider_instance.get_children():
		if child.name == "HSlider":
			slider = child
			break

	if slider == null:
		print("HSlider node not found!")
		return

	
	# Connect the slider value change signal
	slider.connect("value_changed", Callable(self, "_on_slider_value_changed"))
	
	# Create the debounce timer
	debounce_timer = Timer.new()
	debounce_timer.wait_time = 0.01  # 0.01 seconds
	debounce_timer.one_shot = true
	debounce_timer.autostart = false
	add_child(debounce_timer)

	# Update the options initially based on the slider value
	_update_options_visibility(int(slider.value))

# Handle slider value change
func _on_slider_value_changed(value: float):
	print("Slider value changed to:", value)
	debounce_timer.start()  # Start the debounce timer
	# Use call_deferred to pass the value with delay
	call_deferred("_on_debounce_timeout", int(value))

# Function to handle the debounce timeout and update visibility
func _on_debounce_timeout(option_number: int):
	print("Debounce timeout reached. Updating visibility.")
	_update_options_visibility(option_number)

# Function to update options visibility based on slider value
func _update_options_visibility(option_number: int):
	# Hide all options initially
	for i in range(2, 7):
		var option = get_node("Option" + str(i))
		if option:
			option.visible = false
	
	# Show the selected option
	var selected_option = get_node("Option" + str(option_number))
	if selected_option:
		selected_option.visible = true
		print("Option", option_number, "is now visible.")

# Function to update options visibility based on slider value
#func _update_options_visibility(option_number: int):
	## Hide all options initially
	#for i in range(2, 7):
		#var option = get_node("Option" + str(i))
		#if option:
			#option.visible = false
	#
	## Show the selected option
	#var selected_option = get_node("Option" + str(option_number))
	#if selected_option:
		#selected_option.visible = true
		#print("Option", option_number, "is now visible.")
#
	## Create an array of tuples for label information
	#var labels = [
		#{"node": "MeshInstance3D", "value": 25},
		#{"node": "MeshInstance3D2", "value": 34},
		#{"node": "MeshInstance3D3", "value": 3},
		#{"node": "MeshInstance3D4", "value": 81},
		#{"node": "MeshInstance3D5", "value": 22},
		#{"node": "MeshInstance3D6", "value": 56}
	#]
#
	## Highlight the first mesh yellow
	#_highlight_first_mesh(option6)
#
	## Iterate through the dictionary and update the Label3D for each MeshInstance3D
	#for label_info in labels:
		#var mesh_instance = option6.get_node(label_info.node)  # Get the MeshInstance3D node
		#if mesh_instance:
			#var label_3d = mesh_instance.get_node("Label3D")  # Get the Label3D child
			#if label_3d:
				#label_3d.text = str(label_info.value)  # Set the text of the Label3D
				#print("Updated", label_info.node, "text to:", label_info.value)
#
	## Perform selection sort and animate the value swaps
	#_selection_sort_with_animation(labels, option6)
#
## Function to highlight the first mesh and then change to green
#func _highlight_first_mesh(option6: Node3D):
	## Highlight the first mesh in yellow
	#var mesh_instance = option6.get_node("MeshInstance3D")  # Get the first MeshInstance3D node
	#if mesh_instance:
		#var material = mesh_instance.get_material_override()
		#if material:
			#material.albedo_color = Color(1, 1, 0)  # Set highlight color to yellow
		#else:
			#var new_material = StandardMaterial3D.new()
			#new_material.albedo_color = Color(1, 1, 0)  # Set highlight color to yellow
			#mesh_instance.set_material_override(new_material)
#
	## Wait for a few seconds then change to green
	#await get_tree().create_timer(3).timeout 
#
	## Now change it to green
	#if mesh_instance:
		#var material = mesh_instance.get_material_override()
		#if material:
			#material.albedo_color = Color(0, 1, 0)  # Set color to green
#
## Function to perform selection sort with animation
#func _selection_sort_with_animation(labels: Array, option6: Node3D):
	#var count = labels.size()
	#
	#for i in range(count):
		#var min_index = i
		#for j in range(i + 1, count):
			#if labels[j].value < labels[min_index].value:
				#min_index = j
#
		## Highlight the current mesh
		#_highlight_mesh(option6, i)  # Highlight current index
		#_highlight_mesh(option6, min_index)  # Highlight minimum found
#
		## Wait to show highlights
		#await get_tree().create_timer(3).timeout 
#
		#if i != min_index:
			## Perform swap
			#_swap_values(labels, i, min_index)
			#await _update_mesh_labels(option6, labels)  # Update mesh labels after swapping
#
			## Change the color of the current mesh to green after the swap
			#_update_mesh_color(option6, i, Color(0, 1, 0))  # Set the current mesh to green
		#else:
			## If already sorted, set the minimum mesh to green
			#_update_mesh_color(option6, min_index, Color(0, 1, 0))  # Set minimum mesh to green
#
		## Reset the minimum mesh to blue after swap if it's not already sorted
		#if i != min_index:
			#_update_mesh_color(option6, min_index, Color(0.4, 0.6, 1))  # Reset to default color (even lighter blue)
#
		## Wait after the swap
		#await get_tree().create_timer(3).timeout 
#
## Function to swap the values in the array
#func _swap_values(labels: Array, index_a: int, index_b: int):
	#var temp_value = labels[index_a].value
	#labels[index_a].value = labels[index_b].value
	#labels[index_b].value = temp_value
#
## Function to update the labels in the meshes
#func _update_mesh_labels(option6: Node3D, labels: Array):
	#for i in range(labels.size()):
		#var mesh_instance = option6.get_node(labels[i].node)  # Get the MeshInstance3D node
		#if mesh_instance:
			#var label_3d = mesh_instance.get_node("Label3D")  # Get the Label3D child
			#if label_3d:
				#label_3d.text = str(labels[i].value)  # Update the text of the Label3D
#
## Function to highlight the current mesh being worked on
#func _highlight_mesh(option6: Node3D, index: int):
	## Reset color of all meshes to lighter blue
	#for i in range(option6.get_child_count()):
		#var mesh_instance = option6.get_child(i)
		#if mesh_instance and mesh_instance.is_in_group("mesh_instances"):  # Ensure only relevant meshes are reset
			#_update_mesh_color(option6, i, Color(0.4, 0.6, 1))  # Reset to default color (even lighter blue)
#
	## Highlight the current mesh
	#var mesh_instance = option6.get_node("MeshInstance3D" + str(index + 1))  # Get the MeshInstance3D node
	#if mesh_instance:
		## Change the color of the mesh to highlight it
		#var material = mesh_instance.get_material_override()
		#if material:
			#material.albedo_color = Color(1, 1, 0)  # Set the highlight color to yellow
		#else:
			## Create a new material if none exists
			#var new_material = StandardMaterial3D.new()
			#new_material.albedo_color = Color(1, 1, 0)  # Set highlight color to yellow
			#mesh_instance.set_material_override(new_material)
#
## Function to update the color of the mesh
#func _update_mesh_color(option6: Node3D, index: int, color: Color):
	#var mesh_instance = option6.get_node("MeshInstance3D" + str(index + 1))  # Get the MeshInstance3D node
	#if mesh_instance:
		#var material = mesh_instance.get_material_override()
		#if material:
			#material.albedo_color = color  # Update the mesh color
