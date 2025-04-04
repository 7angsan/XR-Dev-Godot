extends StaticBody3D

signal clicked(value: int)

@onready var label: Label3D = $ValueLabel
@onready var mesh: MeshInstance3D = $SphereMesh

func _ready():
	label.render_priority = 1  # Makes label render on top of other 3D elements
	#print("🧩 SphereNode ready. Signal 'clicked' is defined:", has_signal("clicked"))

func set_label(text: String) -> void:
	if label:
		label.text = text

func pointer_event(event: XRToolsPointerEvent) -> void:
	#print("🎯 Pointer event received on:", label.text)

	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		print("🟡 PRESSED event on Sphere:", label.text)
		
		for conn in get_signal_connection_list("clicked"):
			if conn.has("target") and conn.has("method"):
				print("🔍 Connected to:", conn["target"], "| method:", conn["method"])
			else:
				print("⚠️ Connection dictionary missing expected keys:", conn)
				
		highlight()
		emit_signal("clicked", int(label.text))

	
func unhighlight() -> void:
	var mat := StandardMaterial3D.new()

	# Match your original SphereMesh settings
	mat.albedo_color = Color8(0, 255, 127, 153)  # Green with 60% opacity (A = 153)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY
	mat.flags_transparent = true
	mat.alpha_scissor_threshold = 0.1
	mat.roughness = 1.0
	mat.metallic = 0.0
	mat.specular = 0.5
	# Leave shading lit (default)

	mesh.material_override = mat


	
func highlight() -> void:
	print("Highlighting sphere with value:", label.text)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.YELLOW
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_texture = null
	mat.flags_transparent = true
	mat.alpha_scissor_threshold = 0.1
	mat.albedo_color.a = 0.6  # Semi-transparent
	mesh.material_override = mat
	
