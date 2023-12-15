extends Window

var ship_r
var ship_d

# Called when the node enters the scene tree for the first time.
func _ready():
	ship_r = get_node("/root/Main/Game/Ship/Rooms")
	ship_d = get_node("/root/Main/Game/Ship/Doors") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(event):
	if event.is_action_pressed("onset_showsystem"):
		if self.visible:
			self.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			self.show()
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	#Terminal Control
	if event.is_action_pressed("ui_accept"):
		$System/Terminal/TextEdit.text = $System/Terminal/TextEdit.text + "$ " + $System/Terminal/LineEdit.text + "\n"
		var cmd = $System/Terminal/LineEdit.text
		if cmd.begins_with("d"):
			term_tsd(cmd)
		elif cmd == "help":
			term_println("Open doors by typing their name \n\n Doors can only stay closed for a short time before the capacitors overheat \n\n Your oxygen will slowly run out \n\n Find oxygen stations to replenish your tank by pressing E on them.")
		$System/Terminal/LineEdit.text = ""

	pass


#Commands for printing a new line with a special color
func term_println(s : String):
	$System/Terminal/TextEdit.text = $System/Terminal/TextEdit.text + s + "\n"

#Toggle a specific door
func term_tsd(d : String): 
	if ship_d.get_node(d):
		if 1 > 0:
			ship_d.get_node(d).emit_signal("toggle_door")
	else:
		term_println("Door not found.")
