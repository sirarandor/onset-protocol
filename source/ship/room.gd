extends StaticBody3D

@export
var rt : String

@export
var sensors = {
	"posx" : false,
	"posz" : false,
	"negx" : false,
	"negz" : false
}

signal r_setup

var rng = RandomNumberGenerator

var scn_o2st
var scn_btst

var scn_fuel
var scn_frec
var scn_comt

@onready
var s_props = get_node("/root/Main/Game/Ship/Props")

@onready
var omnilight : OmniLight3D = $Ceiling/OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	scn_o2st = ResourceLoader.load("res://scenes/ship/props/StationOxygen.tscn")
	scn_btst = ResourceLoader.load("res://scenes/ship/props/StationRecharge.tscn")

	scn_fuel = ResourceLoader.load("res://scenes/ship/props/FuelCell.tscn")
	scn_frec = ResourceLoader.load("res://scenes/ship/props/FuelReciever.tscn")
	scn_comt = ResourceLoader.load("res://scenes/ship/props/CommunicationTerminal.tscn")

	$Glyph/Name.text = name
	rng = RandomNumberGenerator.new()
	omnilight.visible = false 
	var r = rng.randf()
	if r > 0.7:
		omnilight.visible = true
	$Inside.connect("body_entered", _r_entered)
	connect("r_setup", _r_setup)

func _process(delta):

	if Data.has_fuel:
		omnilight.visible = true
		omnilight.light_energy = 0.5

	if $Sensors/PosX.get_collider():
		sensors["posx"] = true
		#print($Sensors/PosX.get_collider().name)
	else: 
		sensors["posx"] = false
		
	if $Sensors/PosZ.get_collider():
		sensors["posz"] = true
	else: 
		sensors["posz"] = false
		
	if $Sensors/NegX.get_collider():
		sensors["negx"] = true
	else: 
		sensors["negx"] = false
		
	if $Sensors/NegZ.get_collider():
		sensors["negz"] = true
	else: 
		sensors["negz"] = false

#Set up the room based on the room type we are. Going to refactor this into multiple functions later
func _r_setup():
	$Glyph/Type.text = rt
	if rt == "Oxygen":
		var o = scn_o2st.instantiate()
		$Props/Holder_StationOxygen.add_child(o)
	if rt == "Recharge":
		var o = scn_btst.instantiate()
		$Props/Holder_StationRecharge.add_child(o)
	if rt == "Storage": 
		var o = scn_fuel.instantiate()
		o.position = $Props/Holder_StorageFuelCell.global_position
		s_props.add_child(o)
	if rt == "Engine": 
		var o = scn_frec.instantiate()
		o.position = $Props/Holder_EngineFuelReciever.global_position
		s_props.add_child(o)
	if rt == "Communications": 
		var o = scn_comt.instantiate()
		o.position = $Props/Holder_CommunicationsTerminal.global_position
		s_props.add_child(o)

func _r_entered(n):
	print(n.name, " entered ", name, " at ", Data.gs_d[name])
	n.emit_signal("nav_ur", name)
