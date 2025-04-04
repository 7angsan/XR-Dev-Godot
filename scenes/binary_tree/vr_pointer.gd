extends RayCast3D

func _ready():
	target_position = Vector3(0, 0, -200)

func _physics_process(delta: float) -> void:
	force_raycast_update()

	#if Input.is_action_just_pressed("trigger_click") or Input.is_action_just_pressed("ui_accept"):
		#print("🔥 Trigger press detected!")

	if is_colliding():
			var collider = get_collider()
			#print("🔦 Ray hit:", collider)
			#print("   - Type:", collider.get_class())
			#print("   - Name:", collider.name)
			#print("   - Path:", collider.get_path())
			#print("   - Collision Layers:", collider.collision_layer)
			
	#else:
		#print("❌ Ray is NOT colliding with anything!")
#
			## Traverse up the tree to find a node that has `pointer_event`
			#var current = collider
			#while current:
				##print("🔍 Checking node:", current.name, " Has pointer_event?:", current.has_method("pointer_event"))
#
				#if current.has_method("pointer_event"):
					#var event = XRToolsPointerEvent.new(
						#XRToolsPointerEvent.Type.PRESSED,
						#self,                        # Origin of ray
						#current,                     # The clicked node
						#get_collision_normal(),      # Surface normal
						#get_collision_point()        # Hit position
					#)
					#current.pointer_event(event)
					#print("✅ pointer_event() sent to:", current.name)
					#break
#
				#current = current.get_parent()
