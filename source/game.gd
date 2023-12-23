extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	print("We are running")
	$Ship.generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Data.has_died = true 
