extends Node

var MenuScene 
var GameScene 
var LobbyScene

var MenuNode 

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuScene = ResourceLoader.load("res://scenes/base/Menu.tscn")
	GameScene = ResourceLoader.load("res://scenes/base/Game.tscn")
	LobbyScene = ResourceLoader.load("res://scenes/base/Lobby.tscn")
	
	var MenuNode = MenuScene.instantiate();
	
	MenuNode.get_node("Label/StartServer").pressed.connect(_server)
	MenuNode.get_node("Label/ConnectClient").pressed.connect(_client)
	
	add_child(MenuNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _server():

	var GameNode = GameScene.instantiate()
	add_child(GameNode)
	
	get_node("Menu").queue_free()
	MenuNode = null

func _client():
	pass
	
