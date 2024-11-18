extends CanvasLayer

@export var square_scene : PackedScene  # Reference to the Square scene
@onready var h_slider := $HSlider       # Reference to the HSlider node
@onready var generate_button := $Button # Reference to the Button node
@onready var container := $VBoxContainer # Node to contain squares (or any other container type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the button's pressed signal to the generate_squares function
	generate_button.connect("pressed", Callable(self, "_generate_squares"))


# Function to generate squares based on the HSlider value
func _generate_squares() -> void:
	# Clear previous squares in the container
	container.clear_children()

	# Get the number of squares to create
	var num_squares = int(h_slider.value)

	# Loop to create each square
	for i in range(num_squares):
		# Instantiate a new square instance from the square_scene
		var square_instance = square_scene.instantiate()
		
		# Randomize a number and set it on the square's label
		var random_number = randi_range(0, 100)  # Randomize between 0 and 100
		square_instance.get_node("Label").text = str(random_number)
		
		# Add the square instance to the container
		container.add_child(square_instance)
