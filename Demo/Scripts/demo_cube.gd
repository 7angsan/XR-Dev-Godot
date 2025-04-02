extends Node3D

var slider_scene: PackedScene
var slider: HSlider

func _ready():
	print("DemoCube initialized.")
	_on_start_pressed()

func _on_start_pressed():
	print("Starting demo...")
	
	# Delay for 5 seconds before starting the demo
	await get_tree().create_timer(5).timeout

	# Ensure Option6 is being accessed correctly
	var option6 = get_node_or_null("Option6")
	if option6:
		print("Option6 found, making it visible.")
		_update_options_visibility(6)
		await get_tree().process_frame
		print("Finished waiting for frame.")
		_update_labels_in_option6()
		print("Finished updating labels in Option6.")
	else:
		print("Error: Option6 not found in the scene tree!")

func _on_slider_value_changed(value: float):
	print("Slider value changed to:", value)
	_update_options_visibility(int(value))

# Function to update options visibility based on slider value
func _update_options_visibility(option_number: int):
	print("Updating visibility for option:", option_number)

	# Hide all options first
	for i in range(2, 7):
		var option = get_node_or_null("Option" + str(i))
		if option:
			option.visible = false
			print("Hiding Option", i)
		else:
			print("Warning: Option", i, "not found.")

	# Make selected option visible
	var selected_option = get_node_or_null("Option" + str(option_number))
	if selected_option:
		print("Before setting visible:", selected_option.visible)
		selected_option.visible = true
		print("After setting visible:", selected_option.visible)
	else:
		print("Error: Option", option_number, "not found!")


# Function to update labels in Option6
func _update_labels_in_option6():
	var option6 = get_node_or_null("Option6")
	if not option6:
		print("Error: Option6 not found!")
		return

	var labels = [
		{"node": "MeshInstance3D1", "value": 25},
		{"node": "MeshInstance3D2", "value": 34},
		{"node": "MeshInstance3D3", "value": 3},
		{"node": "MeshInstance3D4", "value": 81},
		{"node": "MeshInstance3D5", "value": 22},
		{"node": "MeshInstance3D6", "value": 56}
	]

	_highlight_first_mesh(option6)

	for label_info in labels:
		var mesh_instance = option6.get_node_or_null(label_info.node)
		if mesh_instance:
			var label_3d = mesh_instance.get_node_or_null("Label3D")
			if label_3d:
				label_3d.text = str(label_info.value)
				print("Updated", label_info.node, "text to:", label_info.value)
			else:
				print("Error: Label3D not found in", label_info.node)
		else:
			print("Error: MeshInstance", label_info.node, "not found!")

	_selection_sort_with_animation(labels, option6)

# Ensure first mesh is always MeshInstance3D1
func _highlight_first_mesh(option6: Node3D):
	var mesh_instance = option6.get_node_or_null("MeshInstance3D1")
	if mesh_instance:
		var material = mesh_instance.get_material_override()
		if not material:
			material = StandardMaterial3D.new()
			mesh_instance.set_material_override(material)

		material.albedo_color = Color(1, 1, 0)  # Yellow
		await get_tree().create_timer(3).timeout
		material.albedo_color = Color(0, 1, 0)  # Green
	else:
		print("Error: MeshInstance3D1 not found in Option6")

# Selection sort with animation
func _selection_sort_with_animation(labels: Array, option6: Node3D):
	var count = labels.size()
	
	for i in range(count):
		var min_index = i
		for j in range(i + 1, count):
			if labels[j]["value"] < labels[min_index]["value"]:
				min_index = j

		_highlight_mesh(option6, i)
		_highlight_mesh(option6, min_index)

		await get_tree().create_timer(3).timeout 

		if i != min_index:
			_swap_values(labels, i, min_index)
			await _update_mesh_labels(option6, labels)
			_update_mesh_color(option6, i, Color(0, 1, 0))  # Green
		else:
			_update_mesh_color(option6, min_index, Color(0, 1, 0))  # Green

		if i != min_index:
			_update_mesh_color(option6, min_index, Color(0.4, 0.6, 1))  # Blue

		await get_tree().create_timer(3).timeout 

# Swap function
func _swap_values(labels: Array, index_a: int, index_b: int):
	var temp_value = labels[index_a]["value"]
	labels[index_a]["value"] = labels[index_b]["value"]
	labels[index_b]["value"] = temp_value

# Update mesh labels after sorting
func _update_mesh_labels(option6: Node3D, labels: Array):
	for i in range(labels.size()):
		var mesh_instance = option6.get_node_or_null(labels[i]["node"])
		if mesh_instance:
			var label_3d = mesh_instance.get_node_or_null("Label3D")
			if label_3d:
				label_3d.text = str(labels[i]["value"])
		else:
			print("Error: MeshInstance3D", labels[i]["node"], "not found!")

# Highlight a mesh
func _highlight_mesh(option6: Node3D, index: int):
	for i in range(option6.get_child_count()):
		var mesh_instance = option6.get_child(i)
		if mesh_instance and mesh_instance.is_in_group("mesh_instances"):
			_update_mesh_color(option6, i, Color(0.4, 0.6, 1))  

	var mesh_instance = option6.get_node_or_null("MeshInstance3D" + str(index + 1))
	if mesh_instance:
		var material = mesh_instance.get_material_override()
		if not material:
			material = StandardMaterial3D.new()
			mesh_instance.set_material_override(material)

		material.albedo_color = Color(1, 1, 0)

# Update mesh colors
func _update_mesh_color(option6: Node3D, index: int, color: Color):
	var mesh_instance = option6.get_node_or_null("MeshInstance3D" + str(index + 1))
	if mesh_instance:
		var material = mesh_instance.get_material_override()
		if not material:
			material = StandardMaterial3D.new()
			mesh_instance.set_material_override(material)

		material.albedo_color = color
