extends CharacterBody3D


const SPEED = 2.5
const ROT_SPEED = 0.05
var JUMP_VELOCITY = 2
var mouse_sens = 0.05
var camera_anglev = 0
var cam
var camh = 8
var rng = RandomNumberGenerator

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	cam = $SubViewport/ThirdPerson
	#$HUD/System.visible = false;
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	rng = RandomNumberGenerator.new()
	
func _process(delta):
		cam.position = position
		cam.position.y = position.y + camh
		$HUD/debug/fps.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "POS: " + str(self.position)
	
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
	if direction:
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
	if event.is_action_pressed("onset_showsystem"):
		if $HUD/Window.visible:
			$HUD/Window.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			$HUD/Window.show()
	
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		$FirstPerson.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
		
	pass
