extends StaticBody3D

var rng = RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	var omnilight : OmniLight3D = $Ceiling/OmniLight3D
	var r = rng.randi_range(0, 1)
	if r == 0:
		omnilight.visible = false
	if r == 1: 
		#omnilight.set("light_color", Color(rng.randf(),rng.randf(),rng.randf()))
		pass

func cng_rs(s):
	pass
