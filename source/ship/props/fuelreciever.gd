extends Node

signal placed

@onready
var s_props = get_node("/root/Main/Game/Ship/Props")
# Called when the node enters the scene tree for the first time.
func _ready():
	placed.connect(_placed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _placed():
	s_props.get_node("Fuel Cell").emit_signal("placed")
	Data.has_fuel = true