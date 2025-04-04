# Author: David Leon
# Date: 11/09/2024
# Implementation: An interactive mode where the user imitates the selection sort algorithm

extends Node3D

var xr_interface: XRInterface

# references to the cube and temp 
var cube = preload("res://cube.tscn")
var temp_init = preload("res://temp.tscn")

# regenerate_button reference 
var regenerate_scene = preload("res://regenerate_ui.tscn")

# border references that surround the cubes 
var border = preload("res://border.tscn")
var temp_border = preload("res://temp_border.tscn")

# access the green color material 
var green_color = preload("res://green.tres")  # Replace with the actual path

var regenerate_instance
var regen_button

# the reference to the temp object 
var temp

# the width from the center of the temp 
var temp_width = 0.1

# all instances to keep track of 
var cube_list = []
var int_list = []
var cube_init_pos = []
var border_list = []
var temp_border_list = []

# the in bounds for the temp that gets set later (these numbers initialized mean nothing)
var min_x_temp = -1
var max_x_temp = 1
var min_y_temp = -2
var max_y_temp = 2
var min_z_temp = -2
var max_z_temp = 2

# the distance between each cube and the initial height of the cubes 
var cube_distance_inbetween = 0.3
var cube_height = 0.055

# below is the reference to the cube that is out of line (the one being moved) 
var index_of_cube_out  # index of the current cube we are moving 
var index_of_cube_out_bool = false # an indicator for if there's a cube out of the line 

var current_position = 0 # the current position of the selection sorting 
var min_index = 0 

# indicators of each phase of memory swapping 
var PHASE_ONE_NOT_COMPLETE: bool = true # minimum value enters the temp position 
var PHASE_TWO_NOT_COMPLETE: bool = true # current postion takes the place of the minimum value's original spot 
var PHASE_THREE_NOT_COMPLETE: bool = true # minimum value takes the place of the current position 

var cube_in_temp_position = -1 # an index for the minimum in the temp position 
var cube_that_took_temp_pos = -1 # an index for current position that is about to go into the minimum's value position 

var current_pos_is_min = false # an indicator if the current position is the minimum value 

# lets have a fixed height to freeze cubes that are not moving 
var fixed_height_to_freeze



func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
		
		
		_start()
		
	else:
		print("OpenXR not initialized, pleaes check if your headset is connected")
	
	
# this function regenerates the list 
func _on_button_pressed():
		print("Button was clicked!")
		# lets regenerate the list and reset everything else 
		
		# reset the phases 
		PHASE_ONE_NOT_COMPLETE = true
		PHASE_TWO_NOT_COMPLETE = true
		PHASE_THREE_NOT_COMPLETE = true
			
		index_of_cube_out_bool = false
		cube_in_temp_position = -1
		cube_that_took_temp_pos = -1
			
		current_pos_is_min = false
		 
		current_position = 0
		
		# delete all the cubes and clear all lists to have a fresh start 
		delete_all_cubes_and_clear_lists()
		
		# regenerate the list
		_start()
		
		
	
func _start():
	randomize()  # Ensures randomness on each run
	var cube_count = randi_range(4, 5)  # Random number between 5 and 10
	var distance = 0
	
	# temp coordinates 
	var temp_z = 0.25
	var temp_y = 0.00255 # was at 0.8
	var border_height = 0.025 # was at 0.8
	var temp_border_height = 0.045
	
	# add each cube to the scene along with its borders 
	for i in range(cube_count):
		
		var cube_instance = cube.instantiate()  # Create a new square instance
		
		add_child(cube_instance)  # Add the square to the scene
		cube_list.append(cube_instance)  # Add the square to the list
		
		
		# Set the position of the square 
		cube_list[i].global_transform.origin = Vector3(distance, cube_height, 0)  
		
		# lets play a border around this cube
		for j in range(4):
			var border_instance = border.instantiate()
			
			if j == 0: # left side border 
				add_child(border_instance) # add the border to the scene 
				border_instance.global_transform.origin = Vector3(distance - 0.1, border_height, 0)
				border_list.append(border_instance)
				
			if j == 1: # right side border 
				add_child(border_instance) # add the border to the scene 
				border_instance.global_transform.origin = Vector3(distance + 0.1, border_height, 0)
				border_list.append(border_instance)
				
			if j == 2: #above side border (negative direction)
				add_child(border_instance) # add the border to the scene 
				border_instance.global_transform.origin = Vector3(distance, border_height, -0.1)
				border_instance.rotation_degrees = Vector3(0, 90, 0)  # Rotate 90 degrees around the Y-axis
				border_list.append(border_instance)
				
			if j == 3: # below side border (positive direction) 
				add_child(border_instance) # add the border to the scene 
				border_instance.global_transform.origin = Vector3(distance, border_height, 0.1)
				border_instance.rotation_degrees = Vector3(0, 90, 0)  # Rotate 90 degrees around the Y-axis
				border_list.append(border_instance)
		
		var label_3d = cube_list[i].get_node("MeshInstance3D/Label3D")  #  get the cube's label 
		var ran_num = randi_range(1, 99) # get a random number from 1 to 10 inclusive on both ends 
		
		# Set the text
		label_3d.text = str(ran_num)  
		
		#add the number to the integer list 
		int_list.append(ran_num)
		
		# add the original position of the cube
		cube_init_pos.append(cube_list[i].global_transform.origin)
		print(str(cube_list[i].global_transform.origin))
		
		
		distance += cube_distance_inbetween # increase the distance for spacing of the cubes 
		
		
		# end of for lop 
	
	# add the temp to the scene
	temp = temp_init.instantiate()
	add_child(temp)
	
	
	temp.global_transform.origin = Vector3(((distance - cube_distance_inbetween) / 2), temp_y, temp_z) # put the temp in the middle of the list 
	
	print("temp position: " + str(temp.global_transform.origin))
	
	# set a boundry around the temp position 
	min_x_temp = temp.global_transform.origin.x - temp_width
	max_x_temp = temp.global_transform.origin.x + temp_width
	min_y_temp = temp.global_transform.origin.y - temp_width
	max_y_temp = temp.global_transform.origin.y + temp_width
	min_z_temp = temp.global_transform.origin.z - temp_width
	max_z_temp = temp.global_transform.origin.z + temp_width
	
	var temp_center = temp.global_transform.origin
	
	# add the border around the temp 
	for j in range(4):
			var temp_border_instance = temp_border.instantiate()
			
			if j == 0: # left side border 
				add_child(temp_border_instance) # add the border to the scene 
				temp_border_instance.global_transform.origin = Vector3(min_x_temp, temp_border_height, temp_center.z)
				border_list.append(temp_border_instance)
				
			if j == 1: # right side border 
				add_child(temp_border_instance) # add the border to the scene 
				temp_border_instance.global_transform.origin = Vector3(max_x_temp, temp_border_height, temp_center.z)
				border_list.append(temp_border_instance)
				
			if j == 2: #above side border (negative direction)
				add_child(temp_border_instance) # add the border to the scene 
				temp_border_instance.global_transform.origin = Vector3(temp_center.x, temp_border_height, min_z_temp)
				temp_border_instance.rotation_degrees = Vector3(0, 90, 0)  # Rotate 90 degrees around the Y-axis
				border_list.append(temp_border_instance)
				
			if j == 3: # below side border (positive direction) 
				add_child(temp_border_instance) # add the border to the scene 
				temp_border_instance.global_transform.origin = Vector3(temp_center.x, temp_border_height, max_z_temp)
				temp_border_instance.rotation_degrees = Vector3(0, 90, 0)  # Rotate 90 degrees around the Y-axis
				border_list.append(temp_border_instance)
	
	
	
	
func _process(delta: float) -> void:
	
	# THIS IS THE PHASE WHERE THE MINIMUM OR MAXIMUM CUBE MUST GET TO THE TEMP POSITION 
	if PHASE_ONE_NOT_COMPLETE: 
		if _check_cube_in_range(cube_list):
			
			 # Check if the CUBE is in the temp
			if cube_list[index_of_cube_out].global_transform.origin.x > min_x_temp and cube_list[index_of_cube_out].global_transform.origin.x < max_x_temp and \
				cube_list[index_of_cube_out].global_transform.origin.y > min_y_temp and cube_list[index_of_cube_out].global_transform.origin.y < max_y_temp and \
				cube_list[index_of_cube_out].global_transform.origin.z > min_z_temp and cube_list[index_of_cube_out].global_transform.origin.z < max_z_temp and \
				_check_if_cube_is_min_or_current(cube_list):
					
				# this is the case where the current position is the minimum 
				if _find_min_index(int_list) == current_position:
					
					# were are going to skip the second phase and go right into the third phase 
					PHASE_TWO_NOT_COMPLETE = false
					cube_list[index_of_cube_out].drop() # drop the cube 
					current_pos_is_min = true
					cube_that_took_temp_pos = index_of_cube_out # note the cube that is in the temp position 
					
				else: 
					cube_list[index_of_cube_out].enabled = false  # Stop further movement
					cube_list[index_of_cube_out].drop() #drop the cube 
					
					
				cube_list[index_of_cube_out].global_transform.origin = temp.global_transform.origin # put the cube in the temp position 
				#cube_list[index_of_cube_out].global_transform.origin.y += 0.09
				cube_list[index_of_cube_out].freeze = true
				cube_list[index_of_cube_out].global_transform.origin.y += 0.05
				#cube_list[index_of_cube_out].freeze = true
				
				
				cube_in_temp_position = index_of_cube_out # save the cube's index that is in the temp position 
				
				index_of_cube_out_bool = false; # reset this to indicate that there are no more cubes that are out of line
				
				PHASE_ONE_NOT_COMPLETE = false # lets exit the first phase 
				
	elif PHASE_TWO_NOT_COMPLETE:
		# IN THIS PHASE WE WANT THE CURRENT POSITION CUBE TO TAKE THE PLACE OF WHERE THE MINIMUM CUBE WAS AT 
		
		if _check_cube_in_range(cube_list): # check if any cubes are out of line 
			
			# create the range for the minimum's cube position 
			var min_x_swap = cube_init_pos[cube_in_temp_position].x - 0.1
			var max_x_swap = cube_init_pos[cube_in_temp_position].x + 0.1
			var min_y_swap = cube_init_pos[cube_in_temp_position].y - 0.2
			var max_y_swap = cube_init_pos[cube_in_temp_position].y + 0.1
			var min_z_swap = cube_init_pos[cube_in_temp_position].z - 0.1
			var max_z_swap = cube_init_pos[cube_in_temp_position].z + 0.1
			
			#print("min x swap: " + str(min_x_swap))
			#print("max x swap: " + str(max_x_swap))
			#print("min y swap: " + str(min_y_swap))
			#print("max y swap: " + str(max_y_swap))
			#print("min z swap: " + str(min_z_swap))
			#print("max z swap: " + str(max_z_swap))
			
			if cube_list[index_of_cube_out].global_transform.origin.x > min_x_swap and cube_list[index_of_cube_out].global_transform.origin.x < max_x_swap and \
				cube_list[index_of_cube_out].global_transform.origin.y > min_y_swap and cube_list[index_of_cube_out].global_transform.origin.y < max_y_swap and \
				cube_list[index_of_cube_out].global_transform.origin.z > min_z_swap and cube_list[index_of_cube_out].global_transform.origin.z < max_z_swap and \
				_check_if_cube_is_min_or_current(cube_list): # if we are in the minimum's cube range and the current cube tyring to go in is the current position cube 
			
				cube_list[index_of_cube_out].enabled = false  # Stop further movement
				cube_list[index_of_cube_out].drop() #drop the cube 
					
				
			#	cube_list[index_of_cube_out].global_transform.origin.y += 0.02
				cube_list[index_of_cube_out].freeze = true # disable the physics for the cube 
				
				
				cube_list[index_of_cube_out].global_transform.origin = cube_init_pos[cube_in_temp_position]  # put the current position cube in the minimum's position 
				#cube_list[index_of_cube_out].global_transform.origin.y -= 0.015 
				#cube_list[index_of_cube_out].global_transform.origin.y += 0.01
				
				cube_that_took_temp_pos = index_of_cube_out # this may confusing, but we do this so we dont check the cube in temp's original position in check_cube_in_range
				
				index_of_cube_out_bool = false  # reset this to indicate that there are no more cubes that are out of line
				
				PHASE_TWO_NOT_COMPLETE = false # lets exit the first phase
			
	elif PHASE_THREE_NOT_COMPLETE:
		# IN THIS PHASE WE WANT THE MINIMUM IN THE TEMP TO GET TO THE CURRENT POSITION 
		if _check_cube_in_range(cube_list): # check if any cubes are out of line
			
			# get the boundry for the current position 
			var min_x_swap = cube_init_pos[cube_that_took_temp_pos].x - 0.1
			var max_x_swap = cube_init_pos[cube_that_took_temp_pos].x + 0.1
			var min_y_swap = cube_init_pos[cube_that_took_temp_pos].y - 0.2
			var max_y_swap = cube_init_pos[cube_that_took_temp_pos].y + 0.1
			var min_z_swap = cube_init_pos[cube_that_took_temp_pos].z - 0.1
			var max_z_swap = cube_init_pos[cube_that_took_temp_pos].z + 0.1
			
			if cube_list[index_of_cube_out].global_transform.origin.x > min_x_swap and cube_list[index_of_cube_out].global_transform.origin.x < max_x_swap and \
				cube_list[index_of_cube_out].global_transform.origin.y > min_y_swap and cube_list[index_of_cube_out].global_transform.origin.y < max_y_swap and \
				cube_list[index_of_cube_out].global_transform.origin.z > min_z_swap and cube_list[index_of_cube_out].global_transform.origin.z < max_z_swap and \
				_check_if_cube_is_min_or_current(cube_list): # if we are in the current position and the cube we are holding is the min then we go in here
					
					cube_list[index_of_cube_out].drop() #drop the cube 
					
					cube_list[index_of_cube_out].global_transform.origin = cube_init_pos[cube_that_took_temp_pos] # snap the cube in the current position 
					
					PHASE_THREE_NOT_COMPLETE = false
					print("we are now out of phase 3 complete")
			
	elif not PHASE_ONE_NOT_COMPLETE and not PHASE_TWO_NOT_COMPLETE and not PHASE_THREE_NOT_COMPLETE: # we must reset everything and swap
			# if we are in here then we completed a cycle of memory swapping 
			print("we have completed a cycle ")
			
			var minimumToSwap = _find_min_index(int_list)
			
			var temp = int_list[current_position]
			
			
			# perform memory swapping on the int_list 
			int_list[current_position] = int_list[minimumToSwap]
			int_list[minimumToSwap] = temp
			
			# update locations 
			cube_init_pos[current_position] = cube_list[minimumToSwap].global_transform.origin
			cube_init_pos[minimumToSwap] = cube_list[current_position].global_transform.origin
			
			var temp_cube = cube_list[current_position]
			
			# perform memory swapping on the cube list 
			cube_list[current_position] = cube_list[minimumToSwap]
			cube_list[minimumToSwap] = temp_cube
			
			
			# reset the phases 
			PHASE_ONE_NOT_COMPLETE = true
			PHASE_TWO_NOT_COMPLETE = true
			PHASE_THREE_NOT_COMPLETE = true
			
			index_of_cube_out_bool = false
			cube_in_temp_position = -1
			cube_that_took_temp_pos = -1
			
			current_pos_is_min = false
			
			# change the color of the cube to indicate that it has been sorted 
			cube_list[current_position].get_node("MeshInstance3D").material_override = green_color
			
			cube_list[current_position].enabled = false
			
			cube_list[current_position].global_transform.origin.y += 0.03
			cube_list[current_position].freeze = true # disable its physics 
			
			
			current_position += 1
			
		
		
# this function checks for a cube that is out of line
func _check_cube_in_range(cube_list_: Array) -> bool:
	
	if (index_of_cube_out_bool): # if there is already a cube out of line there is no need to check anything 
		return true
	
	if (not index_of_cube_out_bool): # 
		
		for i in range(current_position, cube_list_.size()): # for each cube check if it is out of the line
			var min_x_ = cube_init_pos[i].x - 0.1
			var max_x_ = cube_init_pos[i].x + 0.1
			var min_y_ = cube_init_pos[i].y - 0.2
			var max_y_ = cube_init_pos[i].y + 0.1
			var min_z_ = cube_init_pos[i].z - 0.1
			var max_z_ = cube_init_pos[i].z + 0.1
			
			 
			if cube_in_temp_position != i and cube_that_took_temp_pos != i : # if the cube is not the current position and minimum value
				if cube_list_[i].global_transform.origin.x < min_x_ or cube_list_[i].global_transform.origin.x > max_x_ or \
					cube_list_[i].global_transform.origin.y < min_y_ or cube_list_[i].global_transform.origin.y > max_y_ or \
					cube_list_[i].global_transform.origin.z < min_z_ or cube_list_[i].global_transform.origin.z > max_z_:
					# and if any other block is out line then
					
					index_of_cube_out = i # get its index 
					index_of_cube_out_bool = true; 
					
					print("there is something out of line at index: " + str(i))
					
					for j in range(current_position, cube_list_.size()): # disable movement for the rest of the cubes and freeze them 
						
						if j != index_of_cube_out:
							cube_list_[j].enabled = false
							
							fixed_height_to_freeze = cube_list_[j].global_transform.origin
							fixed_height_to_freeze.y += 0.01
							
							
							cube_list_[j].freeze = true
							cube_list_[j].global_transform.origin = fixed_height_to_freeze #reset this back so it does not grow 
							
							if (j == cube_in_temp_position):
								cube_list_[j].global_transform.origin.y -= 0.01
							
							
							
					
					return true # we found a cube that is out of line 
					
			elif PHASE_THREE_NOT_COMPLETE and i == cube_in_temp_position: # if we are in the third phase we also want to check if temp is out
				
				if cube_list[i].global_transform.origin.x < min_x_temp or cube_list[i].global_transform.origin.x > max_x_temp or \
				cube_list[i].global_transform.origin.y < min_y_temp or cube_list[i].global_transform.origin.y > max_y_temp or \
				cube_list[i].global_transform.origin.z < min_z_temp or cube_list[i].global_transform.origin.z > max_z_temp:
					
					index_of_cube_out = i
					index_of_cube_out_bool = true; 
					
					print("temp is something out of line at index: " + str(i))
					
					for j in range(current_position, cube_list_.size()): # disable movement for the rest of the cubes 
						
						if j != index_of_cube_out:
							cube_list_[j].enabled = false
							
							fixed_height_to_freeze = cube_list_[j].global_transform.origin
							fixed_height_to_freeze.y += 0.01
							
							cube_list_[j].freeze = true
							cube_list_[j].global_transform.origin = fixed_height_to_freeze #reset this back so it does not grow 
							
							
							
					return true
				  
	return false
	
# THIS FUNCTION CHECK IF BLOCK CAN GO IN THE TEMP, IF NOT IT GOES BACK WHERE IT WAS 
func _check_if_cube_is_min_or_current(cube_list_: Array) -> bool: 
	
	var the_min_index = _find_min_index(int_list) # get the minimum value 
	
	
	for i in range(current_position, cube_list_.size()): #check if the current block we have is the minimum or the current position 
		if index_of_cube_out == the_min_index or index_of_cube_out == current_position and not PHASE_ONE_NOT_COMPLETE: #or index_of_cube_out == current_position:
			print("in the if statement ")
			
			#we we must make all the cubes movable agian 
			for j in range(current_position, cube_list_.size()):
				cube_list_[j].enabled = true
				cube_list_[j].freeze = false
					
			return true
					
					
	# oh no the user put the wrong rectangle we must put it back 
	cube_list_[index_of_cube_out].drop()
	cube_list_[index_of_cube_out].global_transform.origin = cube_init_pos[index_of_cube_out]
	
	
	print("not in the if statement")
	
	index_of_cube_out_bool = false # it back where it was so lets also reset this indicating that there is no cube out of line
	
	if PHASE_ONE_NOT_COMPLETE or current_pos_is_min:
		#we we must make all the cubes movable agian 
		for j in range(current_position, cube_list_.size()):
			cube_list_[j].enabled = true
			cube_list_[j].freeze = false
			
	elif PHASE_TWO_NOT_COMPLETE:
		for j in range(current_position, cube_list_.size()):
			if j != cube_in_temp_position:
				cube_list_[j].enabled = true
				cube_list_[j].freeze = false
				
	elif PHASE_THREE_NOT_COMPLETE:
		for j in range(current_position, cube_list_.size()):
			if j != cube_that_took_temp_pos:
				cube_list_[j].enabled = true
				cube_list_[j].freeze = false
				
	
	
	return false
	
	
# this function finds the index of the smallest value in the list 
func _find_min_index(cube_int_list: Array) -> int: 
	
	var minimum = cube_int_list[current_position]
	var start = current_position 
	
	for i in range(start, cube_int_list.size()):
		if minimum > cube_int_list[i]:
			minimum = cube_int_list[i]
			start = i
			
	return start 
	
	
	
#	this function deletes all cubes in the list 
func delete_all_cubes_and_clear_lists():
		# Iterate over each cube in the list
		for cube in cube_list:
			# Remove the cube from the scene
			cube.queue_free()
			
		for border in border_list:
			# Remove the border from the scene 
			border.queue_free()
			
		for temp_border in temp_border_list:
			# Remove the temp border from the scene
			temp_border.queue_free()
		# Clear the lists to remove all references
		cube_list.clear()
		int_list.clear()
		cube_init_pos.clear()
		border_list.clear()
		temp_border_list.clear()
		
		# get rid of the temp
		temp.queue_free()
		
