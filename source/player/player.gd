extends Node

var pchar
var cam

const camh = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	pchar = get_node("CharacterBody3D")
	cam = get_node("Camera3D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# I really don't like doing this but this is the only way I can keep the camera and main node stapled to the player character.
	# Ah well. Someone run the math to check if this is worse than just updating the position every time.

		
	if self.position != pchar.position:
		self.position = pchar.position
	


