extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LineEdit.text_changed
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		$TextEdit.text = $TextEdit.text + "$ " + $LineEdit.text + "\n"
		
		match $LineEdit.text:
			"help":
				term_help()
			_:
				term_println("Not authorized.")
		$LineEdit.text = ""
				
#Commands for printing a new line with a special color
func term_println(s : String):
	$TextEdit.text = $TextEdit.text + s + "\n"
	
# Huge list of terminal commands goes here :)
func term_help():
	term_println("Welcome to the world of pain. This is sheer utter misery, god has left me.")
