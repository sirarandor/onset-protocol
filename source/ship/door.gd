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
		$Sliding/Glyph.modulate = Color(100,0,0)
		$Timer.start()
		state = "closed"
	elif state == "closed":
		$AnimationPlayer.play("door_open")
		$AudioStreamPlayer3D.play()
		$Sliding/Glyph.modulate = Color(0,100,0)
		state = "open"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("open_door", _open_door)
	connect("close_door", _close_door)
	connect("toggle_door", _toggle_door)

	$Sliding/Glyph/Sigil.text = name
	$Area3D.name = name
	
	state = "open"
	$AnimationPlayer.play("door_open")
	$Sliding/Glyph.modulate = Color(0,100,0)
	
#unc _process(delta):
	#emit_signal("open_door"

func _on_timer_timeout():
	if state == "closed": 
		_toggle_door()
	pass # Replace with function body.
