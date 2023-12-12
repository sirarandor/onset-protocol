extends Control

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
	if event.is_action_pressed("ui_accept"):
		$TextEdit.text = $TextEdit.text + "$ " + $LineEdit.text + "\n"
		var cmd = $LineEdit.text
		if cmd.begins_with("d"):
			term_tsd(cmd) 
		
		
		#match $LineEdit.text:
		#	"help":
		#		term_help()
		#	"rooms":
		#		term_rooms()
		#	"doors": 
		#		term_doors()
		#	_:
		#		term_println("Not authorized.")
		
		$LineEdit.text = ""
				
#Commands for printing a new line with a special color
func term_println(s : String):
	$TextEdit.text = $TextEdit.text + s + "\n"
	
# Huge list of terminal commands goes here :)
func term_help():
	term_println("Welcome to the world of pain. This is sheer utter misery, god has left me.")

#Toggle a specific door
func term_tsd(d : String): 
	if ship_d.get_node(d):
		ship_d.get_node(d).emit_signal("toggle_door")
	else:
		term_println("Door not found.")

func term_rooms(): 
	for c in ship_r.get_children():
		term_println(c.name)
	term_println("Nyet")

func term_doors():
	for c in ship_d.get_children():
		c.emit_signal("toggle_door")
	term_println("Activated all doors.")
