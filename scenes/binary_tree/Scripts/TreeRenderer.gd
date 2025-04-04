extends Node3D

var sphere_scene = preload("res://scenes/binary_tree/GameModes/SphereNode.tscn")
var node_map = {}  # ✅ Maps value → SphereNode (for click detection)

# Constants for positioning
const PLATFORM_Z = -11.0  # ✅ Keep all nodes on the same Z
const START_HEIGHT = 14.5  # Higher starting root node
const LEVEL_HEIGHT = 3.0  # Moves each child downward
const INITIAL_SPACING = 6.0  # Initial horizontal spacing

func render_tree(root, parent_node, depth=0, x_offset=0.0, spacing=INITIAL_SPACING, node_map={}) -> Node3D:
	""" Recursively generates and positions tree nodes in 3D """
	if root == null:
		return null  # No node to render
		
	if depth == 0:
		node_map.clear()  # ✅ Clear previous map when rendering a new tree

	# Calculate new position for the node (✅ Ensures downward placement)
	var y_position = START_HEIGHT - (depth * LEVEL_HEIGHT)  # Moves children downward each level
	var x_position = x_offset * (spacing / (pow(0.5, depth)))  # Keeps correct horizontal spacing

	# Create and position the node
	var sphere = sphere_scene.instantiate()
	#sphere.name = "Sphere_" + str(sphere.value)
	#sphere.input_pickable = true
	sphere.position = Vector3(x_position, y_position, PLATFORM_Z)  # ✅ Lock initial Z

	# Debug: Pre-frame check
	#print("[NODE CREATED] Value:", root.value, "| Position:", sphere.position)

	# Add node to parent
	parent_node.add_child(sphere)
	
	# ✅ Store value -> SphereNode reference
	node_map[root.value] = sphere

	# Ensure SphereNode has set_label() function before calling
	if sphere.has_method("set_label"):
		sphere.set_label(str(root.value))
	else:
		print("⚠ Warning: set_label() method not found in SphereNode!")

	# ✅ Wait for the engine to fully process the node placement
	await get_tree().process_frame

	# ✅ Override global Z after placement (prevents misalignment)
	var global_pos = sphere.global_transform.origin
	sphere.global_transform.origin = Vector3(global_pos.x, y_position, PLATFORM_Z)

	# Debugging: Post-frame check
	#print("[POST FRAME] Node:", root.value, "| Final Global Position:", sphere.global_transform.origin)

	# Reduce spacing for the next level and calculate new offsets
	var next_spacing = spacing / 2.0
	var left_offset = -next_spacing  # Left child moves left
	var right_offset = next_spacing  # Right child moves right

	# Render children
	var left_sphere = null
	if root.left:
		left_sphere = await render_tree(root.left, sphere, depth + 1, left_offset, next_spacing, node_map)
		if left_sphere:
			await get_tree().process_frame
			connect_nodes(sphere.global_transform.origin, left_sphere.global_transform.origin, parent_node)

	var right_sphere = null
	if root.right:
		right_sphere = await render_tree(root.right, sphere, depth + 1, right_offset, next_spacing, node_map)
		if right_sphere:
			await get_tree().process_frame
			connect_nodes(sphere.global_transform.origin, right_sphere.global_transform.origin, parent_node)

	return sphere  # Return node for connections

func connect_nodes(start_pos, end_pos, parent):
	var start = Vector3(start_pos.x, start_pos.y, PLATFORM_Z - 0.01)
	var end = Vector3(end_pos.x, end_pos.y, PLATFORM_Z - 0.01)

	var direction = end - start
	var full_length = direction.length()
	var node_radius = 0.5  # Approximate radius of each SphereNode

	# Trim the connection to avoid overlapping the spheres
	var adjusted_start = start + direction.normalized() * node_radius
	var adjusted_end = end - direction.normalized() * node_radius
	var length = (adjusted_end - adjusted_start).length()
	var mid_point = adjusted_start + (adjusted_end - adjusted_start) * 0.5

	# Create the cylinder mesh
	var cylinder = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = 0.05
	mesh.bottom_radius = 0.05
	mesh.height = length
	mesh.radial_segments = 8
	cylinder.mesh = mesh

	# Make it white
	var material = StandardMaterial3D.new()
	#material.albedo_color = Color.SKY_BLUE
	#material.albedo_color = Color(0.36, 0.25, 0.20)  # RGB for a deep brown
	material.albedo_color = Color(0.59, 0.29, 0.0)  # RGB for a classic brown
	#material.albedo_color = Color(139/255.0, 69/255.0, 19/255.0)  # Proper brown!

	cylinder.material_override = material

	# Apply rotation + position
	var transform = Transform3D()
	transform.origin = mid_point
	transform = transform.looking_at(adjusted_end, Vector3.UP)
	transform.basis = transform.basis.rotated(transform.basis.x, deg_to_rad(90))

	cylinder.transform = transform

	# Add to TreeRenderer (self)
	self.add_child(cylinder)
