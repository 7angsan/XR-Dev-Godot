extends Node3D

# Turing Machine Pieces 
var TM_Walls = preload("res://Turing_Machines/TM_assests/TM_Wall_Seperators.tscn")
var TM_Floor_Ceiling = preload("res://Turing_Machines/TM_assests/TM_Floor_Ceiling.tscn")
var TM_Back_Wall = preload("res://Turing_Machines/TM_assests/TM_Back_Wall.tscn")

# Table with symbols 
var Table_Tape_Symbols = preload("res://Turing_Machines/TM_assests/Tape_Symbol_Table.tscn")

#var TM_UI_Input_Load = preload("res://Turing_Machines/TM_assests/Tape_Input_UI.tscn");
#var TM_UI_Input 
var States

# Y heights: Floor: 1, Ceiling: 1.31, Wall: 1.155, Back Wall: 1.16

# Turing Machine Floor Coordinates 
var TM_X = 6.4
var TM_Y = 1.5
var TM_Z = 0

#Turing Machine Ceiling Coordinates 
var TM_X_C = 6.4
var TM_Y_C = 1.81
var TM_Z_C = 0

# Turing Machine wall coordinates 
var TM_Wall_Y = 1.655
var TM_Wall_Z = 0
var TM_Wall_X = 0.005

# Turing Machine Back Wall Coordinates 
var TM_BW_X = 6.4
var TM_BW_Z = 0.2
var TM_BW_Y = 1.66

# Tape Table Coordinates
var Tape_Table_X = 13.8
var Tape_Table_Y = 0.5
var Tape_Table_Z = -5

# Tape UI Coordinates
#var Tape_UI_X = 0; 
#var Tape_UI_Y = 5; 
#var Tape_UI_Z = 5; 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting program")
	# Create the tape
	_createTape() 
	
	# Create the table
	_createTapeTable()
	
	# Creates tape UI and gets the reference 
	#_createTapeUI()
	
	# Get the states
	#States = TM_UI_Input.get_node("Viewport2Din3D/TmUi/Control/ColorRect/MarginContainer/VBoxContainer/LineEdit")
	#States.connect("text_submitted", Callable(self, "_on_text_submitted"))
	
	
	

#func _on_text_submitted(new_text):
#	print("User submitted text: ", new_text)

# Puts in UI in the scene
#func _createTapeUI() -> void:
#	TM_UI_Input  = TM_UI_Input_Load.instantiate()
	
#	TM_UI_Input.global_transform.origin = Vector3(Tape_UI_X, Tape_UI_Y, Tape_UI_Z)
#	add_child(TM_UI_Input)




# Creates the table with tape symbols
func _createTapeTable() -> void:
	
	var TM_Table = Table_Tape_Symbols.instantiate()
	
	TM_Table.global_transform.origin = Vector3(Tape_Table_X, Tape_Table_Y, Tape_Table_Z)
	add_child(TM_Table)






# Creates the tape machine 
func _createTape() -> void:
	var TM_F = TM_Floor_Ceiling.instantiate() 
	
	TM_F.global_transform.origin = Vector3(TM_X, TM_Y, TM_Z)
	add_child(TM_F) # add the floor and cieling  to the scene
	
	# lets add the walls
	var num_walls = 41
	var distance_between_walls = 0.32
	var Wall_X = TM_Wall_X
	
	# add the walls 
	for j in range(num_walls):
		var TM_Wall = TM_Walls.instantiate()
		
		TM_Wall.global_transform.origin = Vector3(Wall_X, TM_Wall_Y, TM_Wall_Z)
		add_child(TM_Wall)
		
		Wall_X += distance_between_walls
		
		
	# add the ceiling 
	var TM_C = TM_Floor_Ceiling.instantiate()
	TM_C.global_transform.origin = Vector3(TM_X_C, TM_Y_C, TM_Z_C)
	add_child(TM_C) # add the floor and cieling  to the scene
	
	# add the back wall
	var TM_BW = TM_Back_Wall.instantiate()
	TM_BW.global_transform.origin = Vector3(TM_BW_X, TM_BW_Y, TM_BW_Z)
	add_child(TM_BW)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_text_edit_text_changed() -> void:
	#States = get_node("TM_Main/TapeInputUi/Viewport2Din3D/TmUi/Control/ColorRect/MarginContainer/VBoxContainer/TextEdit")
	#print("User submitted text: ", States)
	print("blah text has changed")
	


func _on_text_edit_2_text_changed() -> void:
	print("blah text has changed 2 ")


func _on_text_edit_3_text_changed() -> void:
	print("blah text has changed 3 ")


func _on_button_pressed() -> void:
	print("button pressed")
