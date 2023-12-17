extends Node

signal close_door
signal open_door
signal toggle_door

var inside = false

var rng = RandomNumberGenerator

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
	if state == "open" and inside == false:
		$AnimationPlayer.play("door_close")
		$AudioStreamPlayer3D.play()
		$Sliding/Glyph.modulate = Color(100,0,0)
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

	$Sliding/Glyph/Name.text = name
	$Inside.name = name
	
	state = "open"
	$AnimationPlayer.play("door_open")
	$Sliding/Glyph.modulate = Color(0,100,0)
	
	rng = RandomNumberGenerator.new()
	$Timer.wait_time = rng.randi_range(64,1024)
	$Timer.start()

func _on_timer_timeout():
	_toggle_door()
	$Timer.wait_time = rng.randi_range(64,1024)
	$Timer.start()
