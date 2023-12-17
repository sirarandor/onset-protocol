extends CharacterBody3D

@onready
var player = $/root/Main/Game/Ship/Players/Player
var mvs = 2
var active = false

signal nav_ur

@export
var nav_room = "r0"

var rng

#Navigation variables
var lp
var nr
var nrp

var player_room_pos
var intruder_room_pos
var deviation_x
var deviation_y

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("nav_setup")
	$Sounds/Timer.connect("timeout", _on_soundtimer)
	$Active.connect("timeout", _on_activate)
	
	nav_ur.connect(_nav_ur)
	#$Sounds/Timer.start()
	$Active.start()
	
	rng = RandomNumberGenerator.new()
	
	
func nav_setup():
	await get_tree().physics_frame
	nr = nav_rdev()
	if Data.gs_d.has(nr):
		nrp = Vector3(Data.gs_d[nr].x, 0, Data.gs_d[nr].y)
	else:
		print("Could not find a roosssssm position at ", nr)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	look_at(player.position)
	#print($Active.time_left)
	
	if active == true:
		if lp != position:
			$Model/AnimationPlayer.play("ArmatureAction")
		else: 
			$Model/AnimationPlayer.stop()
		nr = nav_rdev()
		if Data.gs_d.has(nr):
			nrp = Vector3(Data.gs_d[nr].x, 0, Data.gs_d[nr].y)
		else:
			print("Could not find a roosssssm position at ", nr)
		if nrp.x < position.x:
			velocity.x = -mvs
			
		if nrp.x > position.x: 
			velocity.x = mvs
			
		if nrp.z < position.z:
			velocity.z = -mvs
			
		if nrp.z > position.z: 
			velocity.z = mvs
			
		print("POS: ", position.round(), " ROOM: ", nav_room, " NEXT ROOM: ", nr)
	#print(nr)
	#print(nav_room)
	if nav_room == player.nav_room:
		velocity = (transform.basis * Vector3(0,0,-1).normalized()) * 4.5
		
	lp = position
	move_and_slide()

#Navigation Room Deviation
#Return the adjacent room that moves us closest to the player, avoiding walls and closed doors. 
func nav_rdev(): 
	player_room_pos   = Data.gs_d[player.nav_room]
	intruder_room_pos = Data.gs_d[nav_room]
 	
	#Obtain the distance from the player's room relative to the intruder's room
	deviation_x = player_room_pos.x - intruder_room_pos.x
	deviation_y = player_room_pos.y - intruder_room_pos.y
	
	#print(deviation_x, " ", deviation_y)
	var current_room = get_node("/root/Main/Game/Ship/Rooms/" + nav_room)
	var direction_result = Vector2(0,0)
	var lost = true

	#Determine which distance is closer

	if deviation_x != 0:
		#Get the room in the positive X direction
		if deviation_x > 0 and current_room.sensors["posx"] == false and lost == true:
			direction_result = Vector2(8,0)
			lost = false
		else: 
			if current_room.sensors["posx"] == false and lost == true:
				direction_result = Vector2(8,0)
		#Get the room in the negative X direction
		if deviation_x < 0 and current_room.sensors["negx"] == false and lost == true:
			direction_result = Vector2(-8,0)
			lost = false
			
	if deviation_y != 0:
		#Get the room in the positive Y direction
		if deviation_y > 0 and current_room.sensors["posz"] == false and lost == true:
			direction_result = Vector2(0,8)
			lost = false
		#Get the room in the negative Y direction
		if deviation_y < 0 and current_room.sensors["negz"] == false and lost == true:
			direction_result = Vector2(0,-8)
			lost = false
			
		
	#print(lost)
	
	#var lost_fix = randi_range(1,4)
	#if lost == true and nav_room == nr:
	#	if current_room.sensors["posx"] == false and lost_fix == 1:
	#		direction_result = Vector2(8,0)
	#		lost = false
	#	if current_room.sensors["negx"] == false and lost_fix == 2:
	#		direction_result = Vector2(-8,0)
	#		lost = false
	#	if current_room.sensors["posz"] == false and lost_fix == 3:
	#		direction_result = Vector2(0,8)
	#		lost = false 
	#	if current_room.sensors["negz"] == false and lost_fix == 4:
	#		direction_result = Vector2(0,-8)
	#		lost = false
	#		print("Found a new position to go to.")
	
	var next_path_room = "null"
	if Data.rs_d.has(intruder_room_pos + direction_result):
		next_path_room = Data.rs_d[intruder_room_pos + direction_result]
	else: 
		print("Failed to find a room to navigate to at ", intruder_room_pos + direction_result, ".")
	
	return next_path_room


func _on_soundtimer():
	$Sounds/Timer.wait_time = rng.randi_range(32,128)
	
	$Sounds/Timer.start()

func _on_activate():
	$Active.wait_time = rng.randi_range(16,128)
	if active == true:
		hide()
		position.y = -5
		active = false
		return
		
	if active == false: 
		var spawn_room = player.nav_room
		
		while spawn_room == player.nav_room:
			spawn_room = Data.gs_a.pick_random()
		
		position = Vector3(Data.gs_d[spawn_room].x, 0, Data.gs_d[spawn_room].y)
		show()
		active = true
		match rng.randi_range(1,3):
			1: 
				$Sounds/Seeking1.play()
			2:
				$Sounds/Seeking2.play()
			3: 
				$Sounds/Seeking3.play()
		

func _nav_ur(r):
	nav_room = r
	print(nav_rdev())
