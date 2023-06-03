extends Node2D

var PORT: int = 8008
var enet_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@onready var camera: Camera2D = $camera
@onready var address: LineEdit = $ui/address
@onready var ui: Control = $ui

func _start_server() -> void:
	ui.visible = false
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_spawn_player(multiplayer.get_unique_id())

func _start_client() -> void:
	ui.visible = false
	
	enet_peer.create_client(address.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func _spawn_player(id: int) -> Guy:
	var player: Guy = load('res://scenes/guy.tscn').instantiate()
	player.name = str(id)
	add_child(player)
	
	return player

func _on_peer_connected(id: int) -> void:
	print('connected %s!' % id)
	_spawn_player(id)

func _on_peer_disconnected(id: int) -> void:
	print('disconnected %s!' % id)
	
	if get_node(str(id)):
		get_node(str(id)).queue_free()

func _on_port_value_changed(value: float) -> void:
	PORT = int(value)
