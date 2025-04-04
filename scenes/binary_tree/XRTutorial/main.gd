extends Node3D

var xr_interface: XRInterface
var viewport: Node

func _ready():
	print("Main scene loaded!")

	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully!")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")

	# Wait for nodes and Viewport2DIn3D to fully initialize
	await get_tree().process_frame

	# Get Viewport2DIn3D
	var viewport_2d = get_node_or_null("Viewport2Din3D")
	if viewport_2d:
		# Use get_viewport() and find_child to safely access BinaryTreeMenu instance
		var menu_scene = viewport_2d.get_viewport().find_child("BinaryTreeMenu", true, false)
		print("✅ BinaryTreeMenu found:", menu_scene)

		if menu_scene and menu_scene.has_signal("find_pressed"):
			menu_scene.find_pressed.connect(_on_find_pressed)
		else:
			print("⚠ BinaryTreeMenu found but does not have 'find_pressed' signal!")
	else:
		print("❌ Viewport2DIn3D not found in Main.tscn!")

func _on_find_pressed():
	""" Handles Find button press to switch to Find.tscn """
	print("Find button pressed! Switching to Find game mode...")
	get_tree().change_scene_to_file("res://scenes/binary_tree/GameModes/Find.tscn")
