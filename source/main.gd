extends Node

var MenuScene 
var GameScene 
var LobbyScene

var MenuNode 

var end = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuScene = ResourceLoader.load("res://scenes/base/Menu.tscn")
	GameScene = ResourceLoader.load("res://scenes/base/Game.tscn")
	LobbyScene = ResourceLoader.load("res://scenes/base/Lobby.tscn")
	
	menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !end:
		if Data.has_died:
			die()
		if Data.has_fuel and Data.has_comm:
			win()

func _start():
	get_node("Menu").queue_free()
	
	var GameNode = GameScene.instantiate()
	add_child(GameNode)
	end = false

func _exit(): 
	get_tree().quit()

func _client():
	pass
	

func die(): 
	get_node("Game").queue_free()
	menu()
	

func win(): 
	get_node("Game").queue_free()
	menu()

func menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	MenuNode = MenuScene.instantiate()
	MenuNode.get_node("Label/Start").pressed.connect(_start)
	MenuNode.get_node("Label/Exit").pressed.connect(_exit)

	if Data.has_died: 
		MenuNode.get_node("bad").show()
		MenuNode.get_node("worse").hide()

	if Data.has_comm:
		MenuNode.get_node("bad").hide()
		MenuNode.get_node("worse").show()


	end = true
	Data.has_comm = false
	Data.has_fuel = false
	Data.has_died = false

	Data.gs_d = {} 
	Data.rs_d = {}
	Data.gs_a = []
	add_child(MenuNode)