extends StaticBody3D

@export
var rt : String

signal r_setup

var rng = RandomNumberGenerator

var scn_o2st
var scn_btst

# Called when the node enters the scene tree for the first time.
func _ready():
	scn_o2st = ResourceLoader.load("res://scenes/ship/props/StationOxygen.tscn")
	
	
	$Glyph/Sigil.text = name
	rng = RandomNumberGenerator.new()
	var omnilight : OmniLight3D = $Ceiling/OmniLight3D
	omnilight.visible = false 
	var r = rng.randf()
	if r > 0.9:
		omnilight.visible = true
	connect("r_setup", _r_setup)

#Set up the room based on the room type we are. Going to refactor this into multiple functions later
func _r_setup():
	$Glyph/Sigil2.text = rt
	
	if rt == "Oxygen":
		var o = scn_o2st.instantiate()
		$Props/Holder_StationOxygen.add_child(o)
