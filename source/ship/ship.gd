extends Node

const gen_floor = 1

const SHIP_SIZE  = 320
const SHIP_ROOMS = 96

# This is a {Vector2 : int} dictionary
var s_td : Dictionary
# This is an {int, : [Vector2, Vector2]} dictionary to contain the id, size and position of every room. index 0 is the position, index 1 is the size. 
var s_rd : Dictionary
var rng
var RoomScene
var DoorScene
var BlockScene

#Room type dictionaries
var rtd_n = ["Communications", "Navigation", "Enviromental", "Reactor", "Engine", "Security"]
var rtd_s = ["Storage", "Breaker", "Cabin"]
var rtd_b = ["Oxygen", "Recharge", "", "", "", "", "", "", "", ""]

#Rooms and Doors counter


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	RoomScene = ResourceLoader.load("res://scenes/ship/Room.tscn")
	DoorScene = ResourceLoader.load("res://scenes/ship/Door.tscn")
	BlockScene = ResourceLoader.load("res://scenes/ship/Block.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# GLOBAL VARIABLES FOR GENERATOR
var gen_c = SHIP_ROOMS
func generate():
	#g_hallways()
	#g_rooms()
	
	for i in range(SHIP_SIZE * -1, SHIP_SIZE):
		for j in range(SHIP_SIZE * -1, SHIP_SIZE):
			s_td[Vector2(i, j)] = 0
	
	for i in range(0, SHIP_SIZE):
		s_rd[i] = [Vector2(0,0), Vector2(0,0)]
	
	#Generate a basic ship layout
	gen_bsl(7,7)
	
	#TODO: Get this working
	#Generate the ship, with 0,0 as the starting point. 
	#gen_rsg(Vector2(0,0), 2, 2)

	#Turn the ship into a scene
	g_sceneify()
	
#Basic Ship Layout Generator.
# This creates a ship of equally sized rooms connected to each other with doors. This is done so that I can work on actually getting a game functional before worrying about 
# the insanity that is randomly sized rooms.
func gen_bsl(rx, ry):
	var p = Vector2(0,0)
	var d = [1,2,3,4]
	var ac = 0
	var ad = 0
	
	for c in SHIP_ROOMS:
					
			#Set up walls around the room to be either filled in or replaced with doors.
			if s_td[Vector2(p.x+(rx/2)+1, p.y)] != 2:
				s_td[Vector2(p.x+(rx/2)+1, p.y)] = 3
				
			if  s_td[Vector2(p.x-(rx/2)-1, p.y)] != 2:
				s_td[Vector2(p.x-(rx/2)-1, p.y)] = 3
				
			if s_td[Vector2(p.x, p.y+(rx/2)+1)] != 4:
				s_td[Vector2(p.x, p.y+(rx/2)+1)] = 5
				
			if s_td[Vector2(p.x, p.y-(rx/2)-1)] != 4:
				s_td[Vector2(p.x, p.y-(rx/2)-1)] = 5
			
			#Check to see if there is already a room where we are, if not, add a room.
			if s_td[p] == 1:
				pass
			else:
				s_td[p] = 1
				var r = RoomScene.instantiate()
				r.position = Vector3(p.x,0,p.y)
				r.name = "r" + str(ac)
				$Rooms.add_child(r)
				Data.gs_d[r.name] = p
				Data.rs_d[p] = r.name
				Data.gs_a.push_back(r.name)
				ac += 1
			
			#Pick a new direction to go to, make sure it isn't backwards. Also add a door to where we want to go.
			var l = d[rng.randi_range(0,2)]
			match l: 
				1:
					s_td[Vector2(p.x+(rx/2)+1, p.y)] = 2
					p.x += rx+1
					d = [1,3,4]
				2:
					s_td[Vector2(p.x-(rx/2)-1, p.y)] = 2
					p.x -= 1+rx
					d = [2,3,4]
				3:
					s_td[Vector2(p.x, p.y+(rx/2)+1)] = 4
					p.y += 1+rx
					d = [1,2,3]
				4:
					s_td[Vector2(p.x, p.y-(rx/2)-1)] = 4
					p.y -= 1+rx
					d = [1,2,4]
	print("Generated ", ac, " of ", SHIP_ROOMS, " rooms.")

	for c in s_td:
		if s_td[c] == 2:
			var dr = DoorScene.instantiate() 
			dr.position = Vector3(c.x, 1.5, c.y)
			dr.name = "d" + str(ad)
			$Doors.add_child(dr)
			ad += 1
			#print("Added a door ",c)
		if s_td[c] == 4: 
			var dr = DoorScene.instantiate() 
			dr.position = Vector3(c.x, 1.5, c.y)
			dr.name = "d" + str(ad)
			dr.rotation_degrees = Vector3(0,90,0)
			$Doors.add_child(dr)
			ad += 1
			#print("Added a door ",c)
		if s_td[c] == 3: 
			var b = BlockScene.instantiate()
			b.position = Vector3(c.x, 1.5, c.y)
			$Doors.add_child(b)
			#print("Added a block ",c)
		if s_td[c] == 5: 
			var b = BlockScene.instantiate()
			b.rotation_degrees = Vector3(0,90,0)
			b.position = Vector3(c.x, 1.5, c.y)
			$Doors.add_child(b)
			#print("Added a block ",c)
	
	#Randomly give room an oxygen station
	for c in ac: 
		var gns = "Rooms/r" + str(c)
		get_node(gns).rt = rtd_b.pick_random()
		#Tell the room to set itself up after we give it it's type
		get_node(gns).emit_signal("r_setup")
		pass 
	
	#Randomly place the Intruder in the ship
	var intruder = ResourceLoader.load("res://scenes/living/Intruder.tscn").instantiate()
	intruder.position = get_node("Rooms/" + Data.gs_a.pick_random()).position
	add_child(intruder)
	
	
	
	

#Recursive Section Generator
# This is the third iteration of the generation function I have been trying to make. 
# This is done by
#  Pick a room position based off the last door placement 
#   Pick a room size
#    Check if room size conflicts with any existing rooms. If it does, choose a new (different) room size
#   Generate room
#    Based off size of room, select how many doors it has
#     Place the doors
#      Check to make sure that the doors do not have anything in front of them in a 3x3 square. If they do, pick a new position. If every position is taken along the edges, door placement fails
#    Generate a new room based off each of the new doors. 
#  Repeat until room counter reaches 0

#TODO:
#How on earth do I offset the position so that the room generates in the right spot? Need to offset by the preselected room size but that doesn't make any sense. 
#  Potetnial fix - Select room size during the door check, offset the value then, and then pass it to the rsg script along with the room size.

#Global functions for g_rsg
var rc = 0

func gen_rsg(p : Vector2, rx, ry):
	
	# Check how many rooms we have generated
	if rc == SHIP_ROOMS:
		return
	else:
		rc += 1
	
	
	# the vector2 "p" is considered the center point in the room, with everything being offset from that 
	# the new p for the next room has to be offset from the previous "p"
	
	for k in range(p.x-rx, p.x+rx):
			for l in range(p.y-ry, p.y+ry):
				s_td[Vector2(k, l)] = 1
				s_rd[rc] = [p, Vector2(rx, ry)]
	
	var ds = int(ceil((rx*ry)/2)) 
	print(ds)
	
	# Door generation script
	for di in ds:
		
		# int : Vector2 dictionary containing all the potential  door locations
		var ndpd = {}
		var ndpc = 0
		
		#Edge checks to find a spot for a new door here
		
		# North Check
		for i in range(p.y-ry, p.y+ry):
				#Check if the spaces around the door are empty. If so, add it too the dict of potential door locations.
				#We're going to do this by hand because it's easier than making a loop. For now. 
				if s_td[Vector2( p.x+rx, i+1)] == 0:
					ndpd[ndpc] = Vector2( p.x+rx, i+1 )
					ndpc += 1
					pass  
				pass
		
		# West Check
		for i in range(p.x-rx, p.x+rx):
				#Check if the spaces around the door are empty. If so, add it too the dict of potential door locations.
				if s_td[Vector2( i-1, p.y-ry )] == 0:
					ndpd[ndpc] = Vector2( i-1,p. y-ry )
					ndpc += 1
					pass  
				pass
				
		# South Check
		for i in range(p.y-ry, p.y+ry):
				#Check if the spaces around the door are empty. If so, add it too the dict of potential door locations.
				if s_td[Vector2( p.x-rx, i-1 )] == 0:
					ndpd[ndpc] = Vector2( p.x-rx, i-1 )
					ndpc += 1
					pass  
				pass
		
		# East Check
		for i in range(p.x-rx, p.x+rx):
				#Check if the spaces around the door are empty. If so, add it too the dict of potential door locations.
				if s_td[Vector2( i+1, p.y+ry )] == 0:
					ndpd[ndpc] = Vector2( i+1, p.y+ry )
					ndpc += 1
					pass  
				pass
				
		# If we haven't found any possible door locations, skip the entire process and try again. This will make sure it doesn't try to double back on itself. 
		# Avoiding the double-backing-bit is the hardest part about all of this, and too much thought has gone into making sure it never happens. 
		if ndpc == 0 :
			continue
		
		# New door vector position
		var ndp = ndpd[rng.randi_range(0, ndpc-1)]
		s_td[ndp] = 1
		print("Placed door at: ", ndp)
		
		# New room sizes. These all have to be even so I can divide the size correctly. It's weird but trust me bro
		var nrxa = [2,4,6,8,10,12,14,16]
		var nrya = [2,4,6,8,10,12,14,16]
		#Selected new room sizes
		var nrx = 0
		var nry = 0
		
		
		# Loop to select a random room size, then check if it fits. If it doesn't, pick a new room size and erase the one that didn't fit. 
		# That way it will eventually find a room that fits.
		var c = true
		while(c == false):
			for i in nrxa:
				for j in nrya: 
					pass
					
			pass
		
		#The new room's position, obtained by offsetting the door position by the size and which side the door was on.
		var nrp = Vector2(0,0)
	
	pass
	
	
	
# Take the dictionary that we just built and add everything to the scene, offsetting everything correctly
# This will be insanely useful for multiplayer later. Turst me bro.
func g_sceneify():
	for i in s_rd:
		pass
		#var room = RoomScene.instantiate();
		#room.position.x = i[0].x
		#room.position.z = i[0].y
			
			
		#print(cell.position)
		#add_child(room)	
