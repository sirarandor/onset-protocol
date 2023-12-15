extends CharacterBody3D


const SPEED = 2.5
var running = false
const ROT_SPEED = 0.05
var JUMP_VELOCITY = 2
var mouse_sens = 0.1
var camera_anglev = 0
var cam
var camh = 8
var rng = RandomNumberGenerator
var in_system

var inter_cast
var inter_name

var stat_act
var stat_up 
@export
var stat_oxy = 100
var stat_oxy_m = 100
@export
var stat_bat = 100
var stat_bat_m = 100
@export
var stat_stm = 100
var stat_stm_m = 100 

@export
var nav_room = "r0"

#Signal to update the room we are in.
signal nav_ur




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	cam = $SubViewport/ThirdPerson
	#$HUD/System.visible = false;
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	rng = RandomNumberGenerator.new()
	
	stat_up = $StatusUpdater
	stat_up.timeout.connect(_status_update)
	
	$Sounds/Ambient/Air.connect("finished", _on_ambient)
	$Sounds/Ambient/Timer.connect("timeout", _on_clunk)
	$Sounds/Ambient/Timer.start()
	
	
	nav_ur.connect(_nav_ur)

	_status_update()
	
func _process(delta):
		cam.position = position
		cam.position.y = position.y + camh
		$HUD/debug/fps.text = str(Engine.get_frames_per_second())
		$HUD/debug/pos.text = str(position.round())
		
		
		inter_cast = $FirstPerson/Interact.get_collider()
		if inter_cast:
			$HUD/Cursor.text = "[" + inter_cast.get("name") + "]"
			inter_name = inter_cast.get("name")
		else:
			$HUD/Cursor.text = ""
			inter_name = ""
			
		
func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you shouwwwald replace UI actions with custom gameplay actions.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !in_system:
		if running and stat_stm > 0:
			stat_stm -= 1
			velocity.x = direction.x * SPEED * 2
			velocity.z = direction.z * SPEED * 2
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		$AnimationPlayer.play("player/p_walking")
	else:
		$AnimationPlayer.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
	#var mp = get_viewport().get_mouse_position()
	#mp.x = mp.x - get_viewport().get_visible_rect().size.x/2
	#mp.y =(mp.y	- get_viewport().get_visible_rect().size.y/2) * -1
	
	#cursed atan2 
	#Had to add offswet because for some reason the player doesn't want to look directly at mouse. This fixed it.
	#rotation.y  = atan2(mp.y - position.y, mp.x - position.x) - (1 + ((PI*2)/10))
	#rotation.y = (atan2(position.y - get_viewport().get_mouse_position().y, position.x - get_viewport().get_mouse_position().x))
	
	#print(position)
		
	move_and_slide()

func _input(event):
		
	if event.is_action_pressed("onset_showsystem") and !$HUD/Window.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		$HUD/Window.show()
		in_system = true
	else:
		$HUD/Window.hide()
	if !$HUD/Window.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		in_system = false
	
	if event is InputEventMouseMotion and !in_system:
		self.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		$FirstPerson.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
	
	if event.is_action_pressed("onset_throw"):
		pass
		
	if event.is_action_pressed("onset_shift") and stat_stm > 0:
		running = true
	if event.is_action_released("onset_shift") or stat_stm <= 0:
		running = false
		
	if event.is_action_pressed("onset_interact"):
		if inter_name == "Oxygen Station":
			stat_act = "filling_o2"
			
	if event.is_action_pressed("onset_interact"):
		if inter_name == "Recharge Station":
			stat_act = "filling_bt"
			
	if event.is_action_released("onset_interact"):
		stat_act = ""


func _status_update():
	if stat_act == "filling_o2" and stat_oxy < stat_oxy_m:
		stat_oxy += 1
		$HUD/Cursor/Info.text = str(stat_oxy).pad_decimals(0)
		#$Sounds/OxygenFilling.play()
	else:
		stat_oxy -= 0.1
		
	if stat_act == "filling_bt" and stat_bat < stat_bat_m:
		stat_oxy += 1
		$HUD/Cursor/Info.text = str(stat_bat).pad_decimals(0)
		#$Sounds/OxygenFilling.play()
	
	
	if stat_act == "":
		$HUD/Cursor/Info.text = ""
		
	if stat_oxy == 0: 
		get_tree().quit()
	
	if !running and stat_stm < stat_stm_m:
		stat_stm += 1
	
	if $Area3D.has_overlapping_areas():
		$Sounds/Death.play()
		get_tree().quit()
	
	$HUD/Window/System/Status/Label/Oxygen.value = stat_oxy
	$HUD/Window/System/Status/Label2/Battery.value = stat_bat
	stat_up.start()
	pass

func _nav_ur(r): 
	nav_room = r
	$HUD/debug/room.text = nav_room
	$HUD/debug/sensors.text = str(get_node("/root/Main/Game/Ship/Rooms/" + nav_room).sensors)
	#$HUD/debug/intruder_counter.text = get_node("/root/Data/Main/Game/Ship/Intruder/Active").time_left

func _on_ambient():
	$Sounds/Ambient/Air.play()
	
func _on_clunk():
	$Sounds/Ambient/Timer.wait_time = rng.randi_range(16,128)
	
	#var r = Data.gs_a.pick_random()
	#$Sounds/Ambient/Clunker.position = Vector3(Data.gs_d[r].x, 0, Data.gs_d[r].y)
	
	match rng.randi_range(1,3):
		1: 
			$Sounds/Ambient/Clunker/Clunking1.play()
		2:
			$Sounds/Ambient/Clunker/Clunking2.play()
		3: 
			$Sounds/Ambient/Clunker/Clunking3.play()
		
	$Sounds/Ambient/Timer.start()
