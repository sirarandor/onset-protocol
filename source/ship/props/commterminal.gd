extends Area3D

signal pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Data.has_fuel:
		$Label3D.text = "No Power."
	else:
		$Label3D.text = "Transmit\nOnset_Protcol\n?"
	
	if Data.has_comm: 
		$Label3D.text = "Transmit\nComplete\n"

func _pressed():
	print("Player touched us. Ew.")
	if Data.has_fuel: 
		Data.has_comm = true
	else: 
		$Label3D.text = "NO POWER"
