extends RayCast3D

func _physics_process(delta: float) -> void:
	# Basically prints the anme of teh object our raycast is hitting
	if is_colliding():
		var hit = get_collider()
		print(hit.name)
