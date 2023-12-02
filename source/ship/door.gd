extends Node

signal close_door
signal open_door
signal toggle_door

@export var state : String

func _close_door(): 
	$AnimationPlayer.play("door_close")
	$AudioStreamPlayer3D.play()
	state = "closed"
	
func _open_door():
	$AnimationPlayer.play("door_open")
	$AudioStreamPlayer3D.play()
	state = "open"

func _toggle_door(): 
	if state == "open":
		$AnimationPlayer.play("door_close")
		$AudioStreamPlayer3D.play()
		state = "closed"
	elif state == "closed":
		$AnimationPlayer.play("door_open")
		$AudioStreamPlayer3D.play()
		state = "open"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("open_door", _open_door)
	connect("close_door", _close_door)
	connect("toggle_door", _toggle_door)
	
	$Sliding/Label3D.text = name
	$Sliding/Label3D2.text = name
	
	state = "closed"
	$AnimationPlayer.play("door_close")
	
#unc _process(delta):
	#emit_signal("open_door")
	

