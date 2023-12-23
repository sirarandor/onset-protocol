extends RigidBody3D

signal grabbed
signal dropped
signal placed

var is_grabbed = false
var is_placed = false

@onready
var carrying = get_node("/root/Main/Game/Ship/Players/Player/FirstPerson/Carrying")
var placing : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	grabbed.connect(_grabbed)
	dropped.connect(_dropped)
	placed.connect(_placed)

	call_deferred("_find_reciever")

func _find_reciever():
	await get_tree().physics_frame
	placing = get_node("/root/Main/Game/Ship/Props/Fuel Reciever/Reciever")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_grabbed or is_placed:
		$CollisionShape3D.disabled = true
	else: 
		$CollisionShape3D.disabled = false

	if is_grabbed:
		position = carrying.global_position
		rotation = carrying.global_rotation

	if is_placed:
		position = placing.global_position
		rotation = placing.global_rotation

func _grabbed():
	is_grabbed = true

func _dropped():
	is_grabbed = false

func _placed():
	print("We were placed at ", placing.global_position)
	is_placed = true
	is_grabbed = false
