extends CharacterBody3D

@onready
var player = $/root/Main/Game/Ship/Players/Player
var rng
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("nav_setup")
	pass # Replace with function body.
	$NavigationAgent3D.path_desired_distance = 0.5
	$NavigationAgent3D.target_desired_distance = 0
	
	$Sounds/Timer.connect("timeout", _on_soundtimer)
	$Sounds/Timer.start()
	
	rng = RandomNumberGenerator.new()
func nav_setup():
	await get_tree().physics_frame
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$NavigationAgent3D.set_target_position(player.position)
	print($NavigationAgent3D.get_next_path_position())

func _physics_process(delta):
	
	var cap: Vector3 = global_position
	var npp: Vector3 = $NavigationAgent3D.get_next_path_position()
	
	look_at(player.position)
	
	velocity = cap.direction_to(npp) * 3.0
	move_and_slide()

func _on_soundtimer():
	$Sounds/Timer.wait_time = rng.randi_range(32,128)
	
	match rng.randi_range(1,3):
		1: 
			$Sounds/Seeking1.play()
		2:
			$Sounds/Seeking2.play()
		3: 
			$Sounds/Seeking3.play()
	
	$Sounds/Timer.start()
