extends Node

class TreeNode:
	var value: int
	var left: TreeNode = null
	var right: TreeNode = null
	var depth: int = 0

	func _init(val, depth_level=0):
		value = val
		depth = depth_level

func insert_node(root: TreeNode, value: int, depth: int) -> TreeNode:
	if root == null:
		return TreeNode.new(value, depth)

	if value == root.value:
		print("⚠ Duplicate value detected:", value)
		return root

	if depth >= 4:
		return root

	if value < root.value:
		root.left = insert_node(root.left, value, depth + 1)
	else:
		root.right = insert_node(root.right, value, depth + 1)

	return root

func generate_random_bst() -> TreeNode:
	var node_count = randi_range(10, 31)
	var used_values := {}

	var root_value = randi_range(1, 99)
	used_values[root_value] = true
	var root = TreeNode.new(root_value, 0)

	while used_values.size() < node_count:
		var new_value = randi_range(1, 99)
		if used_values.has(new_value):
			continue

		root = insert_node(root, new_value, 0)
		used_values[new_value] = true

	return root
