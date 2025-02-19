extends Node3D

var xr_interface: XRInterface

# Turing Machine Pieces 
var TM_Walls = preload("res://Turing_Machines/TM_assests/TM_Wall_Seperators.tscn")
var TM_Floor_Ceiling = preload("res://Turing_Machines/TM_assests/TM_Floor_Ceiling.tscn")
var TM_Back_Wall = preload("res://Turing_Machines/TM_assests/TM_Back_Wall.tscn")

# Delta Table Pieces 
var Delta_Cell = preload("res://Turing_Machines/TM_assests/Delta_Cell.tscn")
var DeltaCol = preload("res://Turing_Machines/TM_assests/DeltaCol.tscn")
var DeltaRow = preload("res://Turing_Machines/TM_assests/DeltaRow.tscn")

# Pedestals for table
var Pedestal = preload("res://Turing_Machines/TM_assests/Tape_Assets/Tape_Alphabet_Pedestals.tscn")
var PedestalX = 13.8
var PedestalY = 1.005
var PedestalZ = -0.2
var Pedestal_List = []

# Tape symbols represented as Squares
var Tape_Symbol = preload("res://Turing_Machines/TM_assests/Tape_Assets/Tape_Symbol.tscn")
var Tape_Symbol_Y = 1.06
var Tape_Symbols_On_Pedestals = []
var Tape_Symbols_XYZ = [] # the locations of where the symbols are placed 

# Delta Table Submission 
var Delta_Sumbit 
var DSX = -5
var DSY = 0.42
var DSZ = -13
var Delta_Data_Valid = false

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

# Tape Symbols Placement on Tape Coordinates 
var TS_X = 12.635
var TS_Y = 1.555
var TS_Z = 0

# Tape Symbol References 
var Symbols_On_Tape_List = []
var Symbols_On_Tape_List_XYZ = []

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

# Delta Cell Top Left Starting Cell
#var DC_X = -10
#var DC_Y = 1
#var DC_Z = 0
var DC_X = -5
var DC_Y = 1
var DC_Z = -11
var Transition_Table_Rows = [] # the states UI elements 
var Transition_Table_Cols = [] # the tape alphabet UI elements 

# matrices to store data 
var matrix_Delta_UI = []
var matrix_Delta_Data = []
var matrix_Delta_Rows_States: Array[String] = []
var matrix_Delta_Cols_Alphabet: Array[String] = []
var String_Input_Tuple: Array[String] = []


# key word for empty cell
var emptyCell = "{}"

var rowsDelta = 5
var colsDelta = 5

# Button logic 
var states_valid = false
var input_string_valid = false
var tape_alphabet_valid = false 


# Head Pointer Coordinates 
var Head_Pointer_X = 12.635
var Head_Pointer_Y = 1.9
var Head_Pointer_Z = 0

# Head Pointer
var Head_Pointer

# Tape UI Coordinates
#var Tape_UI_X = 0; 
#var Tape_UI_Y = 5; 
#var Tape_UI_Z = 5; 


# turing machines user actions 
# q1 is always the starting state 
var Current_State = "q1"
var Current_Symbol_Holding
var Head_Pointer_To_Symbol_In_Tape = 0

# Turing Machine User Phases 
var Tape_Checks_Current_Head_Complete = false 
var User_Has_Written_To_Tape_Complete = false
var User_Has_Moved_The_Head_Pointer = false
var Cycle_Complete = false
var Turing_Machine_Accepted_Or_Rejected = false


# The location of the tuple where are currently looking at in the delta table: 
var Current_Tuple_X
var Current_Tuple_Y

# logic for writing to the tape
var Symbols_Unfreeze = false
var User_Holding_Symbol
var Is_User_Holding_Symbol = false 

# the current tuple itself
var Curr_Delta_Tuple : Array[String] = []

# Move arrow 
var move_Head_Left = false 
var move_Head_Right = false 
var Head_Moved = false

# Pretty transition table elements 
var Pretty_Transition_Table_Cell = preload("res://Turing_Machines/TM_assests/Tape_Assets/Clean_Delta_Table_Display_Cell.tscn")
var Pretty_Transition_Table = []
var Tuple_To_Highlight_X = 0
var Tuple_To_Highlight_Y = 0

# Accept/Reject UI
var Accept_Reject = preload("res://Turing_Machines/TM_assests/Tape_Assets/Accept_Or_Reject_String_Indicator.tscn")
var Accept_Reject_Ref
var Input_String
var Reject = false
var Accept = false

# TM UI 
var TM_UI_Submitted = false 

# add languages button logic
var Added_Lang1 = false
var Added_Lang2 = false
var Added_Lang3 = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
		
		print("Starting program")
		# Create the tape
		_createTape() 
	
		# Create the table
		_createTapeTable()
		
		
		#_build_Delta_Matrix() 
		
		#_get_delta_data()
		
		
		#var dataCell = Delta_Cell.instantiate()
		#dataCell.global_transform.origin = Vector3(DC_X, DC_Y, DC_Z)
		#add_child(dataCell)
		
		#var dataCell2 = Delta_Cell.instantiate()
		#dataCell2.global_transform.origin = Vector3(DC_X, DC_Y, DC_Z + 1.6)
		#add_child(dataCell2)
		
		#var dataCellLine = dataCell.get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect/MarginContainer/VBoxContainer/LineEdit")
		
		# Connect the text_submitted signal to a function in the same script
		#dataCellLine.connect("text_submitted", Callable(self, "_on_dataCell_text_submitted"))
		
		
		# this is how we access the data
		#var text = dataCellLine.text
		
	else:
		print("OpenXR not initialized, pleaes check if your headset is connected")
	
	
	
	

func _process(delta: float) -> void:
	if Delta_Data_Valid: # if we have valid delta data we may proceed 
		
		if !Turing_Machine_Accepted_Or_Rejected: # if the turing machines has not rejected or accepted a string
			if !Tape_Checks_Current_Head_Complete: # if we have not check the head pointer yet 
				if _Tape_Checks_Cur_Head():
					
					if Current_State == "qA" or Current_State == "QA":
						_Accept_State()
						Turing_Machine_Accepted_Or_Rejected = true
					
					Tape_Checks_Current_Head_Complete = true
				else: # we have rejected the input due to incorrect symbols in input string or no edges available 
					
					_Reject_State()
					Turing_Machine_Accepted_Or_Rejected = true
			elif !User_Has_Written_To_Tape_Complete: # if the user has not written to the tape 
				if _check_User_Writes_To_Tape():
					print(" The user has sucessfully written to the tape ")
			elif !User_Has_Moved_The_Head_Pointer: # if the user has not moved the head pointer yet 
				if _check_User_Moves_Head():
					User_Has_Moved_The_Head_Pointer = true
					print(" The user has successfully move the head pointer ")
			elif !Cycle_Complete: # if we have not completed a cycle yet
				
				# update head pointer locaiton 
				if move_Head_Left:
					if Head_Pointer_To_Symbol_In_Tape != 0: # if we are not at the very left edge 
						Head_Pointer_To_Symbol_In_Tape -= 1
				if move_Head_Right:
					if Head_Pointer_To_Symbol_In_Tape != Symbols_On_Tape_List.size() - 1: # if we are not at the very right edge 
						Head_Pointer_To_Symbol_In_Tape += 1
						
				Current_State = Curr_Delta_Tuple[0] # update the current state to where we tranistion to
				
				# lets reset logic statements
				move_Head_Left = false
				move_Head_Right = false
				Head_Moved = false
				Tape_Checks_Current_Head_Complete = false
				User_Has_Written_To_Tape_Complete = false
				User_Has_Moved_The_Head_Pointer = false
				Cycle_Complete = false
				
				#update UI transition table
				_update_Pretty_UI_Delta_Table()
			
#END_PROCESS###############################################################################################################################



# we the tape rejects we make the indicator red 
func _Reject_State() -> void:
	var Acc_Rej_Color = Accept_Reject_Ref.get_node("Viewport2Din3D/Viewport/AcceptReject2d/Control/ColorRect2/ColorRect")
	Acc_Rej_Color.color = Color(1, 0, 0)
	
	var Acc_Rej_Text = Accept_Reject_Ref.get_node("Viewport2Din3D/Viewport/AcceptReject2d/Control/ColorRect2/ColorRect/RichTextLabel")
	Acc_Rej_Text.text = "Tape Rejects: " + Input_String
	
	Reject = true 
	
	print(" we have rejected the input string ")
# END_Reject_State#########################################################################################################################


# we the tape rejects we make the indicator red 
func _Accept_State() -> void:
	var Acc_Rej_Color = Accept_Reject_Ref.get_node("Viewport2Din3D/Viewport/AcceptReject2d/Control/ColorRect2/ColorRect")
	Acc_Rej_Color.color = Color(0, 1, 0)
	
	var Acc_Rej_Text = Accept_Reject_Ref.get_node("Viewport2Din3D/Viewport/AcceptReject2d/Control/ColorRect2/ColorRect/RichTextLabel")
	Acc_Rej_Text.text = "Tape Accepts: " + Input_String
	
	Accept = true
	
	print(" The Turing accepted the string  ")
# END_Reject_State#########################################################################################################################



# this function lets the user know what current state they are at
# what head points too
# and the current tuple that should be looked at 
func _update_Pretty_UI_Delta_Table() -> void: 
	
	if Current_State == "qA" or Current_State == "QA" or Current_State == "qR" or Current_State == "QR" or Current_State == emptyCell: # i dont want to update anything if im going to an accept state 
		return 
		
	var num_rows = Pretty_Transition_Table.size()
	var num_cols = Pretty_Transition_Table[0].size()
	
	var inner_Cell_Color = Color("696969") # default color grey 
	
	# mark previous tuple back to white 
	var cell_color_prev = Pretty_Transition_Table[Tuple_To_Highlight_Y][Tuple_To_Highlight_X].get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect")
	cell_color_prev.color = inner_Cell_Color # set the specified cell to the color grey 
	
	
	for j in range(num_cols): # lets look through the alphabet set 
		var PTTCell = Pretty_Transition_Table[0][j]
		
		var PTTCell_Text = PTTCell.get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect/RichTextLabel") # get pretty cell's text 
		var Head_Pointer_Text = Symbols_On_Tape_List[Head_Pointer_To_Symbol_In_Tape].get_node("MeshInstance3D/Label3D") # get head pointer's symbol's text 
		
		var cell_color = PTTCell.get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect") # get its color 
		
		if PTTCell_Text.text == Head_Pointer_Text.text: # if we have seen the alphabet symbol which head points to we mark it 
			cell_color.color = Color(0, 0, 1) # set the specified cell to the color blue 
			Tuple_To_Highlight_X = j # update tuple's x coordinate
		else:
			cell_color.color = Color(0, 0, 0) # set the specified cell to the color white to negate previous color change 
				
				
	for i in range(num_rows): # lets look through the set of states 
		var PTTCell = Pretty_Transition_Table[i][0]
		var PTTCell_Text = PTTCell.get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect/RichTextLabel") # get pretty cell's text 
			
		var cell_color = PTTCell.get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect") # get its color 
		
		if PTTCell_Text.text == Current_State: # if we have seen the current state we want we mark it
			cell_color.color = Color(0, 0, 1) # set the specified cell to the color blue 
			Tuple_To_Highlight_Y = i # update tuple's y coordinate
		else:
			cell_color.color = Color(0, 0, 0) # set the specified cell to the color white to negate previous color change 
			
	# mark the tuple with new coordinates in the UI
	var cell_color = Pretty_Transition_Table[Tuple_To_Highlight_Y][Tuple_To_Highlight_X].get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect")
	cell_color.color = Color(0, 0, 1) # set the specified cell to the color blue
# END_Update_Pretty_UI_Delta_Table#########################################################################################################################



# build pretty UI so we can see what state we are in
func _build_Pretty_UI_Delta_Table() -> void:
	var X = TS_X
	var Y = (1.6 * (rowsDelta + 1)) # lets start at the very top left 
	var Z = 3.5
	# save the out x value for the accept or reject UI element
	var Reject_Accept_X 
	var Reject_Accept_Y = 3.1
	var Reject_Accept_Z = 3
	
	for i in range(rowsDelta + 1):
		Pretty_Transition_Table.append([])
		for j in range(colsDelta + 1):
			var PTTCell = Pretty_Transition_Table_Cell.instantiate()
			var PTTCell_Text = PTTCell.get_node("Viewport2Din3D/Viewport/Cdtdc2d/Control/Panel/ColorRect/RichTextLabel")
			
			if i == 0 and j == 0: # leave top left blank 
				pass
			elif i == 0 and j >= 1: # if we are at row 0 then we need to put in the tape alphabet symbols
				PTTCell_Text.text = matrix_Delta_Cols_Alphabet[j - 1] # remember colsDelta comes from the size of matrix_dleta_cols_alphabet
			elif j == 0 and i >= 1: # when we are at leftmost we have a state
				PTTCell_Text.text = matrix_Delta_Rows_States[i - 1] 
			else:
				PTTCell_Text.text = ", ".join(matrix_Delta_Data[i - 1][j - 1])
			
			PTTCell.global_transform.origin = Vector3(X, Y, Z)
			add_child(PTTCell)
			Pretty_Transition_Table[i].append(PTTCell)
			
			X -= 1.6
			Reject_Accept_X = X 
		X = TS_X
		Y -= 1.1
		
	
	Accept_Reject_Ref = Accept_Reject.instantiate()
	Accept_Reject_Ref.global_transform.origin = Vector3(Reject_Accept_X - 2, Reject_Accept_Y, Reject_Accept_Z)
	add_child(Accept_Reject_Ref) # lets add the reference to the add and reject UI to the scene 
	
# END_CHECK_USER_MOVES_HEAD#########################################################################################################################



# we prompt the user to move the head left or right depending on the current tuple 
func _check_User_Moves_Head() -> bool: 
	if Curr_Delta_Tuple[2] == "L" || Curr_Delta_Tuple[2] == "l":
		move_Head_Left = true
	elif Curr_Delta_Tuple[2] == "R" || Curr_Delta_Tuple[2] == "r":
		move_Head_Right = true
	else: 
		print("Something went wrong in check user moves head, we did not get R,r or L,l")
	
	return Head_Moved
# END_CHECK_USER_MOVES_HEAD#########################################################################################################################



# in this function we check whether the user has written to the tape 
func _check_User_Writes_To_Tape() -> bool: 
	# i want to unfreeze the symbols on the table so the user can grab them
	var Tape_Symbols_Length = Tape_Symbols_On_Pedestals.size()
	
	if !Symbols_Unfreeze:
		for i in range(Tape_Symbols_Length):
			Tape_Symbols_On_Pedestals[i].enabled = true # make the symbol pickable
			Tape_Symbols_On_Pedestals[i].freeze = false # enable its physics 
		Symbols_Unfreeze = true # we have unfrozen the symbols 
			
			
	# now we must check for when the user pulls out a symbol
	#var Pedestal_Out_Dist = 0.025 # the distance to go out of bounds wrt the pedestal exactly 
	# but i want it to be pulled out a little more so the blocks don't collide
	var Pedestal_Out_Dist = 0.075
	
	for j in range(Tape_Symbols_Length): # for each block check if its out of its pedestal 
		if (
			Tape_Symbols_On_Pedestals[j].global_transform.origin.x - 0.05 > Tape_Symbols_XYZ[j].x + Pedestal_Out_Dist
			or Tape_Symbols_On_Pedestals[j].global_transform.origin.x + 0.05 < Tape_Symbols_XYZ[j].x - Pedestal_Out_Dist
			or Tape_Symbols_On_Pedestals[j].global_transform.origin.z - 0.05 > Tape_Symbols_XYZ[j].z + Pedestal_Out_Dist
			or Tape_Symbols_On_Pedestals[j].global_transform.origin.z + 0.05 < Tape_Symbols_XYZ[j].z - Pedestal_Out_Dist
		):
			
			if Is_User_Holding_Symbol: # if the user is already holding a symbol and moves another one out 
				
				User_Holding_Symbol.queue_free() # delete the symbol the user is currently holding
				User_Holding_Symbol = Tape_Symbols_On_Pedestals[j] # this is the symbol the user  just pulled 
				
				var Symbol_To_Add = Tape_Symbol.instantiate() # lets add the new tape symbol 
				Symbol_To_Add.global_transform.origin = Tape_Symbols_XYZ[j] # lets add its previous location 
		
				var Symbol_Text = Symbol_To_Add.get_node("MeshInstance3D/Label3D")
				Symbol_Text.text = matrix_Delta_Cols_Alphabet[j] # get the data from the symbols matrix 
				add_child(Symbol_To_Add)
				Tape_Symbols_On_Pedestals[j] = Symbol_To_Add # this is the new symbol on the table 
				
			else: # if we werent previously holding a symbol 
				User_Holding_Symbol = Tape_Symbols_On_Pedestals[j]
				Is_User_Holding_Symbol = true 
				
				var Symbol_To_Add = Tape_Symbol.instantiate() # lets add the new tape symbol 
				Symbol_To_Add.global_transform.origin = Tape_Symbols_XYZ[j] # lets add its previous location 
		
				var Symbol_Text = Symbol_To_Add.get_node("MeshInstance3D/Label3D")
				Symbol_Text.text = matrix_Delta_Cols_Alphabet[j] # get the data from the symbols matrix 
				
				add_child(Symbol_To_Add) # add the symbol back to its pedestal 
				Tape_Symbols_On_Pedestals[j] = Symbol_To_Add # save its reference for checking if its out of bounds agian 
			
			
	
	
	var Head = Symbols_On_Tape_List[Head_Pointer_To_Symbol_In_Tape] # get the symbol on tape which head points to 
	# lets make a boundry around it 
	var X_Range_Pos = Head.global_transform.origin.x + 0.155
	var X_Range_Neg = Head.global_transform.origin.x - 0.155
	var Y_Range_Pos = Head.global_transform.origin.y + 0.25
	var Y_Range_Neg = Head.global_transform.origin.y - 0.06
	var Z_Range_Pos = Head.global_transform.origin.z + 0.15
	var Z_Range_Neg = Head.global_transform.origin.z - 0.15
	# now we must check for when the user pulls out a symbol
	
		
	if Is_User_Holding_Symbol: # we only check if the user is trying to write to the tape if they are holding a symbol
		if ( # if the symbol we are holding is in the cell which the head points too
			User_Holding_Symbol.global_transform.origin.x + 0.05 < X_Range_Pos and User_Holding_Symbol.global_transform.origin.x - 0.05 > X_Range_Neg
			and User_Holding_Symbol.global_transform.origin.y + 0.05 < Y_Range_Pos and User_Holding_Symbol.global_transform.origin.y - 0.05 > Y_Range_Neg
			and User_Holding_Symbol.global_transform.origin.z + 0.05 < Z_Range_Pos and User_Holding_Symbol.global_transform.origin.z - 0.05 > Z_Range_Neg
		):
			var Holding_Symbol_Text = User_Holding_Symbol.get_node("MeshInstance3D/Label3D").text # get the symbol's text that we are holding 
			
			if Holding_Symbol_Text == Curr_Delta_Tuple[1]: # if the tape symbols are the same we can write to the tape 
				Head.queue_free() # delete the cube which head points too
				
				# force the user to drop the symbol 
				User_Holding_Symbol.drop()
				# Make it so the user cannot move that symbol 
				User_Holding_Symbol.enabled = false
				
				# write to the tape 
				print(" here is to place it: ", Symbols_On_Tape_List_XYZ[Head_Pointer_To_Symbol_In_Tape])
				User_Holding_Symbol.global_transform.origin = Symbols_On_Tape_List_XYZ[Head_Pointer_To_Symbol_In_Tape] 
				User_Holding_Symbol.rotation_degrees = Vector3(0, 0, 0)  # Resets rotation to (0,0,0)
				
				User_Holding_Symbol.freeze = true
				
				Symbols_On_Tape_List[Head_Pointer_To_Symbol_In_Tape] = User_Holding_Symbol # update the symbols on tape list to hold the new symbol
				
				# freeze the rest of the cubes on the table because this phase is complete
				for z in range(Tape_Symbols_Length):
					Tape_Symbols_On_Pedestals[z].enabled = false # make the symbol not pickable
					Tape_Symbols_On_Pedestals[z].freeze = true # remove its physics
				Symbols_Unfreeze = false # reset this for the next time the user has to write to the tape 
				
				Is_User_Holding_Symbol = false # reset 
				User_Has_Written_To_Tape_Complete = true # we have completed the phase of user writing to the tape 
				
				return true
			else:
				print(" the text are not the same! ")
	return false 
# END_CHECK_USER_WRITES_TO_TAPE#########################################################################################################################



# in this function we are checking whether we reject the input string or continue to process it 
func _Tape_Checks_Cur_Head() -> bool:
	
	if Current_State == "qA" or Current_State == "QA": 
		return true 
	if Current_State == "qR" or Current_State == "QR":
		return false
	
	var row 
	var col 
	var Found_X = false
	var Found_Y = false 
	
	for i in range(matrix_Delta_Rows_States.size()): # search the states list to find the current state X
		if (Current_State == matrix_Delta_Rows_States[i]): # find where the state is in the data array 
			row = i
			Found_Y = true 
			break
				
	for j in range(matrix_Delta_Cols_Alphabet.size()): # find where the symbol is in the alphabet data array 
		var Symbol_Text = Symbols_On_Tape_List[Head_Pointer_To_Symbol_In_Tape].get_node("MeshInstance3D/Label3D").text # get symbol text on tape which head currently points to
		if(matrix_Delta_Cols_Alphabet[j] == Symbol_Text):
			col = j
			Found_X = true 
			break
			
	if Found_X and Found_Y:
		Current_Tuple_Y = row # get the matrix location for the tuple
		Current_Tuple_X = col 
		
		if matrix_Delta_Data[row][col].size() == 1: # if we have not edge to another node then the turing machine rejects input 
			print(" We have no edges to traverse to: ", matrix_Delta_Data[row][col])
			return false
			
		Curr_Delta_Tuple = matrix_Delta_Data[row][col]
		
		print(" Here is the current delta tuple: ", Curr_Delta_Tuple)
		
		return true 
	else:
		return false 
# END_TAPE_CHECKS_CURR_HEAD#########################################################################################################################





####################################################################################
#
# THE CODE BELOW HANDLES USER INPUT FROM UI ELEMENTS 
# THE CODE BELOW CONSTRUCTS THE DELTA MATRIX AND TAPE AND PLACES SYMBOLS ON THE 
# TAPE AND TABLE 
#
####################################################################################



# place all the pedestals on the scene where each cube is going to sit in 
func _place_Pedestals_and_Tape_Symbols() -> void:
	
	for i in range(colsDelta):
		var Pedestal_To_Add = Pedestal.instantiate() # get the pedestal
		Pedestal_To_Add.global_transform.origin = Vector3(PedestalX, PedestalY, PedestalZ)
		Pedestal_List.append(Pedestal_To_Add)
		add_child(Pedestal_To_Add)
		
		var Symbol_To_Add = Tape_Symbol.instantiate() # lets add the tape symbol 
		Symbol_To_Add.global_transform.origin = Vector3(PedestalX, Tape_Symbol_Y, PedestalZ)
		
		var Symbol_Text = Symbol_To_Add.get_node("MeshInstance3D/Label3D")
		Symbol_Text.text = matrix_Delta_Cols_Alphabet[i] # get the data from the symbols matrix 
		
		add_child(Symbol_To_Add)
		Symbol_To_Add.enabled = false # make the symbol not pickable
		Symbol_To_Add.freeze = true # remove its physics
		Tape_Symbols_On_Pedestals.append(Symbol_To_Add)
		Tape_Symbols_XYZ.append(Symbol_To_Add.global_transform.origin) # add each symbols original location 
		
		PedestalZ -= 0.5 # lets have a spacing of 0.5
		
# END_PLACE_PEDESTALS_AND_TAPE_SYMBOLS#########################################################################################################################




# place the input string in the tape and the blank symbols 
func _place_Input_String_And_Blanks() -> void:
	var Num_Input_Symbols_To_Place = 40 # we are going to place 39 cubes on the tape 
	var Input_String_Tuple_Size = String_Input_Tuple.size() # get the size of input string tuple
	var Distance_Between_Symbols = 0.32
	var TS_X_ = TS_X
	
	for i in range(Num_Input_Symbols_To_Place):
		var Input_Symbol = Tape_Symbol.instantiate()
		var Input_Symbol_Text = Input_Symbol.get_node("MeshInstance3D/Label3D") # get the cubes text 
		
		if i < Input_String_Tuple_Size:
			Input_Symbol_Text.text = String_Input_Tuple[i] # get the symbol from input symbols data 
		else:
			Input_Symbol_Text.text = "_" # otherwise we have a blank symbol 
			
		# Now lets add the symbol to the scene 
		Input_Symbol.global_transform.origin = Vector3(TS_X_, TS_Y, TS_Z)
		
		add_child(Input_Symbol)
		Input_Symbol.enabled = false # make the symbol not pickable
		Input_Symbol.freeze = true # remove its physics
		
		Symbols_On_Tape_List_XYZ.append(Input_Symbol.global_transform.origin) # save the symbols original location 
		
		Symbols_On_Tape_List.append(Input_Symbol) # store the reference of the tape symbol on tape 
		
		# lets make sure we put the next week in the correct position 
		TS_X_ -= Distance_Between_Symbols
		
# PLACE_INPUT_STRING_AND_BLANKS#########################################################################################################################



# in this function we build the delta matrix 
func _build_Delta_Matrix()-> void: 
	
	if colsDelta > 5: # make a dynamic adjustment to the delta table position 
		var Increase_Distance = colsDelta - 5
		Increase_Distance = Increase_Distance * 1.6
		DC_Z -= Increase_Distance
	
	
	var x = DC_X; 
	var y = DC_Y; 
	var z = DC_Z; 
	
	
	var DRowZ; # then will be used for the row names 
	
	# Fill with zeros
	for i in range(rowsDelta):
		matrix_Delta_UI.append([])  # Add new row
		for j in range(colsDelta): 
			var dataCell = Delta_Cell.instantiate()
			dataCell.global_transform.origin = Vector3(x, y, z)
			add_child(dataCell)
			
			matrix_Delta_UI[i].append(dataCell)  # Add column with default value
			
			z += 1.6 
			
		y += 1.1
		DRowZ = z - 1.6
		z = DC_Z 
		
	y -= 1.1
	var DColX = DC_X
	var DColY = y + 0.66
	var DColZ = DC_Z
	
	var TA_to_Start = colsDelta - 1
	# x y z a t & ... etc 
	for k in range(colsDelta): # lets add the rows (tape symbols) to the scene 
		var delta_col = DeltaCol.instantiate()
		delta_col.global_transform.origin = Vector3(DColX, DColY, DColZ)
		
		# get the rich text label 
		var delta_col_text = delta_col.get_node("Viewport2Din3D/Viewport/DRC/Control/ColorRect/RichTextLabel")
		
		# Set text to "c"
		delta_col_text.text = matrix_Delta_Cols_Alphabet[TA_to_Start] # i started to get values from the end so everything matchtes up 
		TA_to_Start -= 1
		
		add_child(delta_col)
		Transition_Table_Cols.append(delta_col)
		
		DColZ += 1.6
		
	var DRowX = DC_X
	var DRowY = DC_Y
	DRowZ += 1.225
	 
	# q1
	# q2
	# q3
	# ...
	# etc
	var States_to_Start = rowsDelta - 1
	
	for l in range(rowsDelta): # lets add the rows (the states) to the matrix
		var delta_row = DeltaRow.instantiate()
		delta_row.global_transform.origin = Vector3(DRowX, DRowY, DRowZ)
		
		# get the rich text label 
		var delta_row_text = delta_row.get_node("Viewport2Din3D/Viewport/DR/Control/ColorRect/RichTextLabel")
		# Set text to "c"
		delta_row_text.text = matrix_Delta_Rows_States[States_to_Start] # i started to get values from the end so everything matchtes up
		States_to_Start -= 1
		
		add_child(delta_row)
		Transition_Table_Cols.append(delta_row)
		
		DRowY += 1.1
		
	
	Delta_Sumbit = get_node("ValidateDeltaTableButton") # get the sumbit button and move it down 
	Delta_Sumbit.global_transform.origin = Vector3(DSX, DSY, DC_Z - 2) # move the button down
		
#END_BUILD_DELTA_MATRIX#########################################################################################################################



# get data from the delta table 
func _get_delta_data() -> void: 
	
	var j = colsDelta - 1
	var i = rowsDelta - 1
	
	# the data cells are placed like this:
	# [x][][x][] 1
	# [][x][][] 0
	#  3  2  1  0
	
	# i need to start at top left cell to get the data in this form:
	# the data cells are placed like this:
	# [x][][x][] 1
	# [][x][][] 0
	#  1  2  3  4
	
	
	var row = 0
	var col = 0
	
	#for i in range(rowsDelta):
	while i >= 0:
		matrix_Delta_Data.append([])  # Add new row
		#for j in range(colsDelta):
		while j >= 0:
			var data_cell = matrix_Delta_UI[i][j].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text
			
			if data_cell == emptyCell: # lets check if we are an empty cell
				var empty_tuple : Array[String] = []
				empty_tuple.append(data_cell)
				
				# i need to add this: matrix_Delta_Data[row].append ...
				matrix_Delta_Data[row].append(empty_tuple) # add the empty cell 
				print("Here is data added: at row: " + str(row) + " and col: " + str(col) + " and data: " + str(matrix_Delta_Data[row][col]))
			else:
				var tuple : Array[String] = _check_valid_delta_data(data_cell) # tuple to return
				
				if tuple.size() == 3: # we have a valid tuple
					matrix_Delta_Data[row].append(tuple) # FIX I need to act as i start at 0 0
					print("Here is data added: at row: " + str(row) + " and col: " + str(col) + " and data: " + str(matrix_Delta_Data[row][col]))
				else: # we have invalid input 
					matrix_Delta_Data.clear()
					print("we had an invalid tuple: ")
					return 
			col += 1
			j -= 1 # end inner while loop 
			
		j = colsDelta - 1
		i -= 1 # end outer loop 
		row += 1
		col = 0 
			
		print("/n")
	Delta_Data_Valid = true # we have a valid delta table 
#END_GET_DELTA_DATA#########################################################################################################################



# in this function we validate the delta table data
func _check_valid_delta_data(delta_cell_input : String) -> Array[String]:
	var tuple : Array[String] = [] # tuple to return 
	
	
	delta_cell_input = delta_cell_input.replace(",", "").replace(" ", "") # remove any commas or spaces
	#print(" here is string comming in: ", delta_cell_input)
 
	var length = len(delta_cell_input)
	#print(" here is its length: ", length)
	
	var extracted_State = "" # the state to extract
	var end = 0 
	
	if length == 5: # if we have this input: ex: q12 x R
	# Extract the state q12
		end = 3
		extracted_State = delta_cell_input.substr(0, end)
	elif length == 4: # if we have this input format: ex: q1 x R
		end = 2
		extracted_State = delta_cell_input.substr(0, end)
	else: # otherwise we must have an invalid format
		print(" we have a tuple that exceeded length")
		return tuple
		
	if extracted_State == "qA" or extracted_State == "QA" or extracted_State == "qR" or extracted_State == "QR": # if we have an accepting state or rejecting state
		pass
	elif !_check_For_Dup_In_List(extracted_State, matrix_Delta_Rows_States): # check if state is in state list 
		print(" this state is not in: ", extracted_State)
		return tuple # its not in
	tuple.append(extracted_State) # add {q12} or {qA}
	
	# Extract "x" (4th character, index 3 or 3rd character, index 2)
	var extracted_Symbol_To_Write = delta_cell_input.substr(end, 1)
	
	if !_check_For_Dup_In_List(extracted_Symbol_To_Write, matrix_Delta_Cols_Alphabet): # check if state is in alphabet tape 
		print(" tape symbol not in: ", extracted_Symbol_To_Write)
		return tuple # its not in
	tuple.append(extracted_Symbol_To_Write) # add {q12, x}
	
	end += 1
	# Extract "R" (5th character, index 4 or 4th character, index 3)
	var extracted_Dir = delta_cell_input.substr(end, 1) 
	
	if !(extracted_Dir == "L" or extracted_Dir == "l") and !(extracted_Dir == "R" or extracted_Dir == "r"):
		print(" Direction not in: ", extracted_Dir)
		return tuple
		
	# we have a successful tuple of length 3
	tuple.append(extracted_Dir) # add {q12, x, R}
	return tuple
		
		
# END_CHECK_VALID_DELTA#########################################################################################################################



# Creates the table with tape symbols
func _createTapeTable() -> void:
	
	var TM_Table = Table_Tape_Symbols.instantiate()
	
	TM_Table.global_transform.origin = Vector3(Tape_Table_X, Tape_Table_Y, Tape_Table_Z)
	add_child(TM_Table)
# END_CREATE_TAPE_TABLE#########################################################################################################################



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
	
# END_CREATE_TAPE#########################################################################################################################


# this function gets the input string and validates it
func _on_input_string_submitted(input_string: String) -> void:
	
	String_Input_Tuple.clear() # in case the user is resubmitting the input string 
	
	Input_String = input_string # save this for reject or accept UI element 
	
	if tape_alphabet_valid: # we check input string when we have a valid set of characters for the tape 
		var cleaned_IS = input_string.replace(",", "").replace(" ", "")
		print(" here is input string: " + cleaned_IS)
		
		if len(cleaned_IS) > 38: 
			print(" Incorret input string: Too long of input string")
			return 
		
		for char in cleaned_IS:
				
			print(" we are accepting input character: " + char)
			String_Input_Tuple.append(char) # add each valid character to the input string tuple 
			
		print(" we have successful input string")
		input_string_valid = true
		
	if TM_UI_Submitted and Delta_Data_Valid: # if the user has already sumbitted a string and wants to sumbit another one:
		_reset_Tape_And_Phases()
			
# ON_INPUT_STRING_SUBMITTED#########################################################################################################################



# the user at any point may choose to add a new input string and process
# the input string 
# the user may not change tape alphabet or set of states unless they completely reset the TM langauge 
func _reset_Tape_And_Phases() -> void:
	for i in range(Symbols_On_Tape_List.size()):
		Symbols_On_Tape_List[i].queue_free() 
		
	Symbols_On_Tape_List.clear()
	Symbols_On_Tape_List_XYZ.clear()
	
	_place_Input_String_And_Blanks() # re add the new symbols on the tape 
	Current_State = "q1"
	Head_Pointer_To_Symbol_In_Tape = 0
	
	# lets reset logic statements
	move_Head_Left = false
	move_Head_Right = false
	Head_Moved = false
	Tape_Checks_Current_Head_Complete = false
	User_Has_Written_To_Tape_Complete = false
	User_Has_Moved_The_Head_Pointer = false
	Cycle_Complete = false
	Symbols_Unfreeze = false
	Turing_Machine_Accepted_Or_Rejected = false
	
	if (Is_User_Holding_Symbol): # if the user is currently holding a cube or its droped somewhere, delete it
		User_Holding_Symbol.queue_free()
		Is_User_Holding_Symbol = false
	
	# freeze the rest of the cubes on the table because we are resetting everything 
	for z in range(Tape_Symbols_On_Pedestals.size()):
		Tape_Symbols_On_Pedestals[z].enabled = false # make the symbol not pickable
		Tape_Symbols_On_Pedestals[z].freeze = true # remove its physics
	
	# these are original head pointer coordinates 
	Head_Pointer_X = 12.635
	Head_Pointer_Y = 1.9
	Head_Pointer_Z = 0
	
	Head_Pointer.global_transform.origin = Vector3(Head_Pointer_X, Head_Pointer_Y, Head_Pointer_Z)
	
	#update UI transition table
	_update_Pretty_UI_Delta_Table()
	
	
# END_RESET_TAPE_AND_PHASES #########################################################################################################################



# this function checks if an input string character exists in the tape alphabet 
func _char_In_Tape_Alphabet(input_char: String) -> bool:
	
	for i in range(colsDelta):
		if input_char == matrix_Delta_Cols_Alphabet[i]:
			return true
	
	return false # we could not find it lets leave 
	
# END_CHAR_IN_TAPE_ALPHABET #########################################################################################################################



# we'll make a check for duplicates function just for better code readability
func _check_For_Dup_In_List(char: String, array: Array[String]) -> bool:
	for i in range(array.size()):
		if char == array[i]:
			return true
			
	return false
# CHECK_FOR_DUPLICATES_IN_LIST#########################################################################################################################



# we go in this function when we submit the states in the UI and then we valid the states
# must be in format q1 q2 ... qf
func _on_states_submitted(set_States: String) -> void:
	
	if !TM_UI_Submitted: # we only go in here if the user has not submitted anything yet 
		matrix_Delta_Rows_States.clear() # in case the user want to resubmit the set of states data 
		
		# Remove extra spaces and split by comma or space
		set_States = set_States.replace(",", "").replace(" ", "")
		print("Here are states: " + set_States)
		
		var someState = ""
		var State_Num = 1
		var States_Length = len(set_States)
		var i = 0
		
		if States_Length < 4:
			print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,qf with atleast 2 states")
			return 
		
		while i < States_Length: #add states q1 q1 .. qF
			
			if set_States[i] != "q" and set_States[i] != "Q":
				print("Incorrect Format, must be format of: q1 q2 q3 ... qf or q1,q2,q3,...,qf with a state starting with q or Q")
				return
				
			if i + 1 == States_Length - 1: # if we are in the very last state 
				if set_States[i + 1] == "F" or set_States[i + 1] == "f":
					someState += set_States[i] + set_States[i + 1] # add the final state qf
					
					print("Here is the state we are adding: ", someState)
					matrix_Delta_Rows_States.append(someState) # add the final state qf
					break
				else:
					print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,qf, we must have a final state ")
					return 
			elif State_Num < 10: # we are looking at single digit numbered states in here 
				if i + 1 < States_Length:
					someState += set_States[i] # add the q 
					if set_States[i + 1] == str(State_Num): # we must match the strict increasing order number 
						someState += set_States[i + 1] # concat the number state
					else:
						print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,qf, states must be in strict increasing order")
						return 
				else:
					print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,qf, state is missing number")
					return 
				print("Here is the state we are adding: ", someState)
				matrix_Delta_Rows_States.append(someState) # add the valid state to the list 
				someState = ""
				State_Num += 1
				i += 2 # we must move past qn and to the next state 
			else: # we have hit double digits 
				if i + 2 < States_Length:
					someState += set_States[i] # add the q 
					
					var Double_Digit_Num = set_States[i + 1] + set_States[i + 2]
					if Double_Digit_Num == str(State_Num): # we must match the strict increasing order number 
						someState += Double_Digit_Num # concat the number state
					else:
						print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,q4, states must be in strict increasing order")
						return 
				else:
					print("Incorrect Format, must be format of: q1 q2 q3 ... q4 or q1,q2,q3,...,q4, state is missing number")
					return 
				print("Here is the state we are adding: ", someState)
				matrix_Delta_Rows_States.append(someState) # add the valid state to the list 
				someState = ""
				State_Num += 1
				i += 3
			
		#Succefull state input 
		print(" we have successful input for states ")
		
		rowsDelta = matrix_Delta_Rows_States.size() # this will be the number of rows we have
		states_valid = true # indicator that we have a valid set of states  
# ON_STATES_SUMBITTED#########################################################################################################################



# we go in here when we enter the tape alphabet in the UI and verify it is valid input 
func _on_tape_alphabet_submitted(tape_alphabet: String) -> void:
	
	if !TM_UI_Submitted: # we only go in here if the user has not submitted anything yet 
		matrix_Delta_Cols_Alphabet.clear() # clear the previous array since the user is resumbitting data 
		
		if states_valid: #we only check tape alphabet when we have a valid set of states 
			var cleaned_TA = tape_alphabet.replace(",", "").replace(" ", "") # get rid of commas and spaces from the input 
			print(" here is tape alphabet: " + cleaned_TA)
			
			var length = len(cleaned_TA)
			
			if length > 10: # i dont want too many characters, 10 is the maximum 
				print(" Incorrect Format for tape alphabet, there are too many characters for tape alphabet")
				# I NEED TO CLEAR THE LIST 
				return 
			
			for char in cleaned_TA:
				
				if char == "_": #ignore underscores they are automatically submitted to the alphabet at the end 
					continue
				
				if _check_For_Dup_In_List(char, matrix_Delta_Cols_Alphabet):
					print("Incorrect Format: You cannot have duplicate character in tape alphabet symbols: ", char)
					return 
				
				print(" we put in tape alphabet: ", char)
				matrix_Delta_Cols_Alphabet.append(char)
			# we have succesfull input 
			matrix_Delta_Cols_Alphabet.append("_")
			colsDelta = length + 1 # this is the number of cols for the matrix 
			
			tape_alphabet_valid = true # an indicator showing that we have a valid tape alphabet 
# END_ON_TAPE_ALPHABET_SUBMITTED#########################################################################################################################



# we create the delta matrix in this function after valid input of states, alphabet, and input string 
func _on_button_TM_UI() -> void:
	if states_valid and tape_alphabet_valid and input_string_valid:
		_build_Delta_Matrix() 
		
		TM_UI_Submitted = true
		
	
# END_ON_BUTTON_TURING_MACHINE_UI#########################################################################################################################



# we get the delta data in this function once the submit button is pressed for the delta table 
func _on_Delta_Button_pressed() -> void:
	_get_delta_data()
	if Delta_Data_Valid:
		
		print(" we have a valid delta table ")
		Delta_Sumbit.global_transform.origin = Vector3(DSX, DSY + 46, DSZ) # move the submit button back up 
		_place_Pedestals_and_Tape_Symbols() # place symbols on the table 
		_place_Input_String_And_Blanks() # place the input symbols on the tape 
		_build_Pretty_UI_Delta_Table() # place the pretty transition table in fron of the user 
		_update_Pretty_UI_Delta_Table() # highlight current state and current head symbol cell
		
		Head_Pointer = get_node("HeadPointer") # get a reference to the head pointer 
		Head_Pointer.global_transform.origin = Vector3(Head_Pointer_X, Head_Pointer_Y, Head_Pointer_Z)
		
		#Let's move the head pointer on top of the tape 
		
# ON_DELTA_BUTTON_PRESSED#########################################################################################################################



# we move the head pointer left in here 
func _on_button_pressed_LEFT() -> void:
	var Arrow_Distance_To_Move = Head_Pointer_X + 0.32
	
	if move_Head_Left:
	
		if Arrow_Distance_To_Move < 12.8: # only move if we are not going past the tape 
			Head_Pointer.global_transform.origin = Vector3(Arrow_Distance_To_Move, Head_Pointer_Y, Head_Pointer_Z)
			Head_Pointer_X = Arrow_Distance_To_Move # update its location 
			
			Head_Moved = true
		else:
			Head_Moved = true
# ON_BUTTON_PRESSED_LEFT#########################################################################################################################



# we move the head pointer right in here 
func _on_button_pressed_RIGHT() -> void:
	var Arrow_Distance_To_Move = Head_Pointer_X - 0.32
	
	if move_Head_Right:
	
		if Arrow_Distance_To_Move > 0: # only move if we are not going past the tape 
			Head_Pointer.global_transform.origin = Vector3(Arrow_Distance_To_Move, Head_Pointer_Y, Head_Pointer_Z)
			Head_Pointer_X = Arrow_Distance_To_Move # update its location
			
			Head_Moved = true
		else:
			Head_Moved = true
# ON_BUTTON_PRESSED_RIGHT#########################################################################################################################



# We reset the entire turing machine environment when the button is pressed 
func _on_RESET_PRESSED() -> void:
	print(" User pressed reset button ")
	
	# reset pedestal coordinates to its original state 
	PedestalX = 13.8
	PedestalY = 1.005
	PedestalZ = -0.2
	
	# delete each pedestal in the scene 
	for i in range(Pedestal_List.size()):
		Pedestal_List[i].queue_free()
	Pedestal_List.clear() # clear any potential garbage references 

	# delete each symbol on the pedestals
	for i in range(Tape_Symbols_On_Pedestals.size()):
		Tape_Symbols_On_Pedestals[i].queue_free()
	Tape_Symbols_On_Pedestals.clear()
	Tape_Symbols_XYZ.clear()
	
	# reset the height where cube gets placed 
	Tape_Symbol_Y = 1.06
	
	
# Delta Table Submission resets
	DSX = -5
	DSY = 0.513
	DSZ = -13
	Delta_Data_Valid = false
	
# Tape Symbols Placement on Tape Coordinates Reset 
	TS_X = 12.635
	TS_Y = 1.555
	TS_Z = 0
	
	# delete all the symbols on the tape
	for i in range(Symbols_On_Tape_List.size()):
		Symbols_On_Tape_List[i].queue_free()
	Symbols_On_Tape_List.clear()
	Symbols_On_Tape_List_XYZ.clear()
	
	DC_X = -5
	DC_Y = 1
	DC_Z = -11
	
	# delete all the data cells in the transition table 
	for i in range(matrix_Delta_UI.size()):
		for j in range(matrix_Delta_UI[i].size()):
			matrix_Delta_UI[i][j].queue_free()
			
	matrix_Delta_UI.clear()
	matrix_Delta_Data.clear()
	matrix_Delta_Rows_States.clear()
	matrix_Delta_Cols_Alphabet.clear()
	String_Input_Tuple.clear()
	
	# delete the UI tape alphabet and set of states elements 
	for i in range(Transition_Table_Cols.size()):
		Transition_Table_Cols[i].queue_free()
	for i in range(Transition_Table_Rows.size()):
		Transition_Table_Rows[i].queue_free()
	Transition_Table_Cols.clear()
	Transition_Table_Rows.clear()
	
	
# key word for empty cell reset, which might not be necessary 
	emptyCell = "{}"
	rowsDelta = 5
	colsDelta = 5
	
# Button logic Reset
	states_valid = false
	input_string_valid = false
	tape_alphabet_valid = false 
	
# Head Pointer Coordinates Reset 
	Head_Pointer_X = 12.635
	Head_Pointer_Y = 1.9
	Head_Pointer_Z = 0
	
	
	# move the arrow and sumbit button up high 
	Head_Pointer.global_transform.origin = Vector3(0, 50, 0)
	Delta_Sumbit.global_transform.origin = Vector3(0, 50, 0)
	
	
# q1 is always the starting state 
	Current_State = "q1"
	Head_Pointer_To_Symbol_In_Tape = 0
	
# Turing Machine User Phases Reset
	Tape_Checks_Current_Head_Complete = false 
	User_Has_Written_To_Tape_Complete = false
	User_Has_Moved_The_Head_Pointer = false
	Cycle_Complete = false
	Turing_Machine_Accepted_Or_Rejected = false
	
	
# logic for writing to the tape Reset
	Symbols_Unfreeze = false
	Is_User_Holding_Symbol = false 
	
	# the current tuple itself Reset
	Curr_Delta_Tuple.clear()
	
	# Move arrow 
	move_Head_Left = false 
	move_Head_Right = false 
	Head_Moved = false
	
	# delete cells in pretty transition table  
	for i in range(Pretty_Transition_Table.size()):
		for j in range(Pretty_Transition_Table[i].size()):
			Pretty_Transition_Table[i][j].queue_free()
	Pretty_Transition_Table.clear()
	Tuple_To_Highlight_X = 0
	Tuple_To_Highlight_Y = 0
	
	# Accept/Reject UI Reset
	Reject = false
	Accept = false
	
	Accept_Reject_Ref.queue_free()
	
	# TM UI 
	TM_UI_Submitted = false 
	
	# add default langauges reset
	Added_Lang1 = false 
	Added_Lang2 = false
	Added_Lang3 = false 
	
# END_BUTTON_RESET#######################################################################################################################



# in this function we add the langauage 0*1* into the transition table 
func _on_button_pressed_Lang1() -> void:
	
	# if we have not yet added this langauged and have submitted the UI data then we can add this langauge 
	if (!Added_Lang1 and TM_UI_Submitted):
		var statesLength = matrix_Delta_Rows_States.size()
		var alphabetLength = matrix_Delta_Cols_Alphabet.size()
		
		# we must meet these requirments to auto write this language to the matrix table 
		if statesLength == 4 and alphabetLength == 5: 
			if( 
				matrix_Delta_Cols_Alphabet[0] == "0" and
				matrix_Delta_Cols_Alphabet[1] == "1" and
				matrix_Delta_Cols_Alphabet[2] == "X" and
				matrix_Delta_Cols_Alphabet[3] == "Y" and 
				matrix_Delta_Cols_Alphabet[4] == "_"
			):
				matrix_Delta_UI[3][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 X R"
				matrix_Delta_UI[3][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf Y R"
				matrix_Delta_UI[3][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qA _ L"
				
				matrix_Delta_UI[2][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 0 R"
				matrix_Delta_UI[2][3].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q3 Y L"
				matrix_Delta_UI[2][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 Y R"
				
				matrix_Delta_UI[1][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q3 0 L"
				matrix_Delta_UI[1][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q1 X R"
				matrix_Delta_UI[1][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q3 Y L"
				
				matrix_Delta_UI[0][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf Y R"
				matrix_Delta_UI[0][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qA _ L"
				
				Added_Lang1 = true
			else: 
				print(" invalid alphabet data for adding language 0*1*")
		else:
			print(" incorrect states or set of alphabet characters to add langauge 0*1* ")
	else:
		print(" user has already added this language (0*1*) or has not submitted UI data")
# END_ON_ADD_LANGUAGE1#######################################################################################################################



# in this function we add the langauage 01*0 into the transition table 
func _on_button_pressed_Lang2() -> void:
	# if we have not yet added this langauged and have submitted the UI data then we can add this langauge 
	if (!Added_Lang2 and TM_UI_Submitted):
		var statesLength = matrix_Delta_Rows_States.size()
		var alphabetLength = matrix_Delta_Cols_Alphabet.size()
		
		# we must meet these requirments to auto write this language to the matrix table 
		if statesLength == 3 and alphabetLength == 5: 
			if( 
				matrix_Delta_Cols_Alphabet[0] == "0" and
				matrix_Delta_Cols_Alphabet[1] == "1" and
				matrix_Delta_Cols_Alphabet[2] == "X" and
				matrix_Delta_Cols_Alphabet[3] == "Y" and 
				matrix_Delta_Cols_Alphabet[4] == "_"
			):
				matrix_Delta_UI[2][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 X R"
				matrix_Delta_UI[2][3].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qR 1 R"
				matrix_Delta_UI[2][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qR _ R"
				
				matrix_Delta_UI[1][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf X R"
				matrix_Delta_UI[1][3].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 Y R"
				matrix_Delta_UI[1][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qR _ R"
				
				matrix_Delta_UI[0][4].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qR 0 R"
				matrix_Delta_UI[0][3].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qR 1 R"
				matrix_Delta_UI[0][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qA _ R"
				
				
				Added_Lang2 = true
			else: 
				print(" invalid alphabet data for adding language 01*0")
		else:
			print(" incorrect states or set of alphabet characters to add langauge 01*0 ")
	else:
		print(" user has already added this language (01*0) or has not submitted UI data")
# END_ON_ADD_LANGUAGE1#######################################################################################################################


# in this function we add the langauage even length palindrome into the transition table 
func _on_button_pressed_Lang3() -> void:
	# if we have not yet added this langauged and have submitted the UI data then we can add this langauge 
	if (!Added_Lang3 and TM_UI_Submitted):
		var statesLength = matrix_Delta_Rows_States.size()
		var alphabetLength = matrix_Delta_Cols_Alphabet.size()
		
		# we must meet these requirments to auto write this language to the matrix table 
		if statesLength == 7 and alphabetLength == 3: 
			if( 
				matrix_Delta_Cols_Alphabet[0] == "a" and
				matrix_Delta_Cols_Alphabet[1] == "b" and
				matrix_Delta_Cols_Alphabet[2] == "_"
			):
				matrix_Delta_UI[6][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 _ R"
				matrix_Delta_UI[6][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q5 _ R"
				matrix_Delta_UI[6][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qA _ L"
				
				matrix_Delta_UI[5][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 a R"
				matrix_Delta_UI[5][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q2 b R"
				matrix_Delta_UI[5][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q3 _ L"
				
				matrix_Delta_UI[4][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q4 _ L"
				
				matrix_Delta_UI[3][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q4 a L"
				matrix_Delta_UI[3][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q4 b L"
				matrix_Delta_UI[3][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q1 _ R"
				
				matrix_Delta_UI[2][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q5 a R"
				matrix_Delta_UI[2][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q5 b R"
				matrix_Delta_UI[2][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q6 _ L"
				
				matrix_Delta_UI[1][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf _ L"
				
				matrix_Delta_UI[0][2].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf a L"
				matrix_Delta_UI[0][1].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "qf b L"
				matrix_Delta_UI[0][0].get_node("Viewport2Din3D/Viewport/DataCellInput/Control/ColorRect2/ColorRect/ColorRect/LineEdit").text = "q1 _ R"
				
				Added_Lang3 = true
			else: 
				print(" invalid alphabet data for adding language 01*0")
		else:
			print(" incorrect states or set of alphabet characters to add langauge 01*0 ")
	else:
		print(" user has already added this language (01*0) or has not submitted UI data")
# END_ON_ADD_LANGUAGE3#######################################################################################################################
