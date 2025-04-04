extends Node3D

# Load BinaryTree script to generate the BST
var binary_tree = preload("res://scenes/binary_tree/Scripts/BinaryTree.gd").new()
var bst_root  # Stores the generated binary search tree
var node_map = {}


# UI Elements inside the Viewport
var viewport
var find_label
var arraylist_label
var new_tree_button
var undo_button
var exit_button

# Reference to TreeRenderer (for rendering BST in 3D)
@onready var tree_renderer = $TreeRenderer

var target_value: int
var arraylist = []

func _ready():
	print("Find scene loaded!")

	# Wait for everything to load before accessing nodes
	await get_tree().process_frame  

	# Get the FindMenu node (Viewport2DIn3D)
	#viewport = $FindMenu  

	await get_tree().process_frame
	var find_ui = $FindMenu.get_viewport().find_child("FindUI", true, false)
	print("✅ find_ui =", find_ui)

	if find_ui:
		for child in find_ui.get_children():
			print(" - Child of find_ui:", child.name)



		if find_ui:
			var ui = find_ui.get_node("UI")  # ✅ Get the Control node inside FindUI
			# ✅ Ensure correct paths to UI elements
			find_label = find_ui.get_node("UI/VBoxContainer/FindLabel")
			arraylist_label = find_ui.get_node("UI/VBoxContainer/ArrayListLabel")
			new_tree_button = find_ui.get_node("UI/HBoxContainer/NewTreeButton")
			undo_button = find_ui.get_node("UI/HBoxContainer/UndoButton")
			exit_button = find_ui.get_node("UI/HBoxContainer/ExitButton")

			# ✅ Check nodes before connecting signals
			if exit_button:
				exit_button.pressed.connect(_on_exit_pressed)
			else:
				print("Error: ExitButton not found!")

			if new_tree_button:
				new_tree_button.pressed.connect(_on_new_tree_pressed)
			else:
				print("Error: NewTreeButton not found!")

			if undo_button:
				undo_button.pressed.connect(_on_undo_pressed)
			else:
				print("Error: UndoButton not found!")

			# ✅ Generate an initial tree when scene loads
			_generate_new_tree()
			#_on_node_clicked(999) #hardcoded to check if arraylist actually updates

		else:
			print("Error: FindUI scene not found inside FindMenu!")
	else:
		print("Error: FindMenu not found in Find.tscn!")

func _on_exit_pressed():
	""" Exits Find mode and returns to the main scene. """
	get_tree().change_scene_to_file("res://scenes/binary_tree/XRTutorial/main.tscn")

func _on_new_tree_pressed():
	""" Generates a new random BST and updates the FindLabel. """
	_generate_new_tree()

func _on_undo_pressed():
	""" Removes the last selected node from the ARRAYLIST. """
	if arraylist.size() > 0:
		var last = arraylist.pop_back()
		print("UNDO: Removed", last, "from arraylist. Now:", arraylist)
		
		_update_arraylist_label()
		
		if node_map.has(last):
			node_map[last].unhighlight()
	else:
		print("⚠️ UNDO: No nodes to undo.")

func _generate_new_tree():
	""" Generates a new BST and displays it in 3D """
	bst_root = binary_tree.generate_random_bst()
	node_map.clear()
	arraylist.clear()
	
	# Pick a non-target root node
	var all_nodes = _get_all_nodes(bst_root)
	all_nodes.erase(bst_root.value)
	target_value = all_nodes[randi() % all_nodes.size()]

	#var used_values = binary_tree.used_values
	#target_value = _pick_random_node(bst_root)  # Pick a random number from the BST

	if find_label:
		print("✅ FindLabel found successfully!")
		print("Target value:", target_value)
		print("FindLabel:", find_label)

		find_label.text = "FIND: " + str(target_value)  # Update FindLabel with target value
	else:
		print("❌ Could not find FindLabel")

	#arraylist.clear()
	

	# ✅ Clear previous tree before rendering a new one
	for child in tree_renderer.get_children():
		tree_renderer.remove_child(child)
		child.queue_free()

	# Render the new tree in 3D
	await tree_renderer.render_tree(bst_root, tree_renderer, 0, 0.0, 6.0, node_map)
	
	# Connect click signals
	for val in node_map.keys():
		var node = node_map[val]
		var this_val = val
		var val_copy = this_val
		#var result = node.clicked.connect(func(): _on_node_clicked(this_val))
	
		print("🧪 Connecting signal for node value:", this_val)
		print("🧪 Node =", node, "| Has clicked signal? ->", node.has_signal("clicked"))
		
		var result = node.connect("clicked", func(value): _on_node_clicked(val_copy))
		print("🧪 Connection result for", this_val, "=", result)  # Should be OK = 0
	
		if result == OK:
			print("🔗 Successfully connected clicked signal for:", this_val)
		else:
			print("❌ Failed to connect clicked signal for:", this_val)
		
	
	_update_arraylist_label()
		
func _on_node_clicked(value: int):
	#print("Sphere clicked!")
	if arraylist.has(value):
		return  # Prevent duplicates

	arraylist.append(value)
	print("🧩 Added to arraylist:", value)
	print("🧠 arraylist now:", arraylist)
	_update_arraylist_label()

	if node_map.has(value):
		node_map[value].highlight()
		print("🟡 Highlighted node:", value)  # Debug print
	# Check if this completes the path
	if value == target_value:
		var expected_path = _find_path(bst_root, target_value)
		if expected_path == arraylist:
			arraylist_label.text = "ARRAYLIST: " + str(arraylist) + "\n You won!"
		else:
			arraylist_label.text = "ARRAYLIST: " + str(arraylist) + "\n You lost!"
			
func _find_path(root, target, path=[]):
	if root == null:
		return []
	if root.value == target:
		return path + [root.value]

	if target < root.value:
		return _find_path(root.left, target, path + [root.value])
	else:
		return _find_path(root.right, target, path + [root.value])

func _pick_random_node(root):
	""" Picks a random node from the BST to be the target. """
	var nodes = _get_all_nodes(root)
	return nodes[randi() % nodes.size()] if nodes.size() > 0 else 0  # Avoid crash if tree is empty

func _get_all_nodes(root) -> Array:
	""" Retrieves all node values from the BST (in-order traversal). """
	if root == null:
		return []
	return _get_all_nodes(root.left) + [root.value] + _get_all_nodes(root.right)

func _update_arraylist_label():
	if arraylist_label:
		print("📦 arraylist contents:", arraylist)
		print("🧩 node_map keys:", node_map.keys())

		var text = "ARRAYLIST: "

		var entries = []
		for val in arraylist:
			if node_map.has(val):
				var node = node_map[val]
				if node.has_node("ValueLabel"):
					var label = node.get_node("ValueLabel")
					entries.append(label.text)
					continue
			# fallback
			entries.append(str(val))

		text += ", ".join(entries)
		print("🧾 Updating label to:", text)
		arraylist_label.text = text
		arraylist_label.queue_redraw()
		print("📋 Label TEXT SET to (after redraw):", arraylist_label.text)

	else:
		print("❌ arraylist_label is NULL!")
