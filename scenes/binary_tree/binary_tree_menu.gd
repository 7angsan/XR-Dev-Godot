extends Control

signal find_pressed  # Define a signal that the 3D world will listen for

@onready var find_button = $ButtonContainer/Find

func _ready():
	# Ensure the signal is connected only once
	if not find_button.pressed.is_connected(_on_find_pressed):
		find_button.pressed.connect(_on_find_pressed)

func _on_find_pressed():
	""" Notify the 3D world that the 'Find' button was pressed """
	emit_signal("find_pressed")
