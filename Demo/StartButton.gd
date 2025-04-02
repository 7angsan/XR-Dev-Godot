extends Button

signal start_demo  # Define a signal

func _ready():
	connect("pressed", _on_start_pressed)  # Use Callable for the connection

func _on_start_pressed():
	print("Button clicked")

	# Load the receiver scene from res://
	var receiver_scene = load("res://Demo/Boxes/DemoCube.tscn")  # Specify the path to your scene

	if receiver_scene:
		var receiver_node = receiver_scene.instantiate()  # Instantiate the scene
		print("Receiver node instanced from scene.")

		# Now you can connect the signal dynamically
		if start_demo.is_connected(receiver_node._on_start_pressed):
			print("Emitting start_demo signal...")
			start_demo.emit()  # Emit signal to start the demo
		else:
			print("Warning: No receivers for start_demo signal!")
	#$"../../../../../Control2/Dialogue".visible = true
	#$"../../../../../Control2".visible = true
	queue_free()  # Remove the start button from the scene
