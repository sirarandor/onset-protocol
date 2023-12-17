extends Window

var ship_r
var ship_d

@export
var player = CharacterBody3D

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
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#Terminal Control
	if event.is_action_pressed("ui_accept"):
		$System/Terminal/TextEdit.text = $System/Terminal/TextEdit.text + "$ " + $System/Terminal/LineEdit.text + "\n"
		var cmd = $System/Terminal/LineEdit.text
		if cmd.begins_with("d"):
			term_tsd(cmd)
		elif cmd.begins_with("r"):
			term_tsr(cmd)
		elif cmd == "help":
			$System/Tutorial.visible = !$System/Tutorial.visible
		$System/Terminal/LineEdit.text = ""

	pass


#Commands for printing a new line with a special color
func term_println(s : String):
	$System/Terminal/TextEdit.text = $System/Terminal/TextEdit.text + s + "\n"

#Toggle a specific door
func term_tsd(d : String): 
	if ship_d.get_node(d):
		if player.stat_bat > 0:
			ship_d.get_node(d).emit_signal("toggle_door")
			player.stat_bat -= 10
	else:
		term_println("Door not found.")

#Teleport to a specific room.
func term_tsr(r : String): 
	if ship_r.get_node(r):
		$/root/Main/Game/Ship/Players/Player.position = ship_r.get_node(r).position
	else:
		term_println("Door not found.")
