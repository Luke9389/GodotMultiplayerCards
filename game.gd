extends Node2D

#var IP_ADDRESS := "3.144.198.65"
var IP_ADDRESS := "127.0.0.1"
var PORT_NUMBER := 8080
var message_count_from_client := 0

var connection_status

var player_one_id := 0
var player_two_id := 0

@onready var status_text = $Panel/VBoxContainer/Status
@onready var messages_from_server: RichTextLabel = $Panel/VBoxContainer/MessagesFromServer


func _ready() -> void:
	# Pull cli arguments from build
	var args = Array(OS.get_cmdline_args())
	print("args: " + str(args))
	
	#if OS.has_feature('dedicated_server'):
	if args.has('-s'):
		print("loading server...")
		start_server()
		#print(multiplayer.get_unique_id())
	else:
		print("loading client...")
		status_text.text = "Starting client"
		start_client()


func start_server():
	print("Starting server...")
	
	multiplayer.peer_connected.connect(self._on_client_connected)
	multiplayer.peer_disconnected.connect(self._on_client_disconnected)
	
	# Create server
	var server = ENetMultiplayerPeer.new()
	server.create_server(PORT_NUMBER, 2)
	multiplayer.multiplayer_peer = server
	
	print('Created server on port: ' + str(PORT_NUMBER))

func start_client():
	multiplayer.connected_to_server.connect(self.connected_to_server)
	multiplayer.server_disconnected.connect(self.disconnected_from_server)
	multiplayer.connection_failed.connect(self._on_connected_fail)
	
	print("Creating client...")
	_update_status_text("Starting client...")
	
	# Create client
	var client = ENetMultiplayerPeer.new()
	var error = client.create_client(IP_ADDRESS, PORT_NUMBER)
	if error:
		return error
	multiplayer.multiplayer_peer = client


# Only called from clients (runs on server)
@rpc("any_peer")
func send_message_to_server(message: String):
	if multiplayer.is_server():
		print("Message received on server: " + message)
		message_count_from_client += 1
		send_message_to_client.rpc("Right back at ya! Count: " + str(message_count_from_client))

# Only called from server (runs on clients)
@rpc("authority")
func send_message_to_client(message: String):
	print("Message received on client: " + message)
	_update_server_response_text(message)


# Client callbacks
func connected_to_server():
	print("Connected to server...")
	_update_status_text("Connected to server...")

func disconnected_from_server():
	print("Disconnected from server...")

func _on_connected_fail():
	print("Connection Failed")
	multiplayer.multiplayer_peer = null

# Server callbacks
func _on_client_connected(clientId):
	print("Client connected: " + str(clientId))
	if player_one_id == 0:
		player_one_id = clientId
	else:
		player_two_id = clientId
		SignalBus.set_up_player_two.emit(clientId)

func _on_client_disconnected(clientId):
	print("Client disconnected: " + str(clientId))


# UI
func _send_message_to_server():
	print("Sending message to server...")
	send_message_to_server.rpc("Hello from client: " + str(multiplayer.get_unique_id()))

func _update_status_text(text):
	status_text.text = "[font_size={45}]" + text + "[/font_size]"

func _update_server_response_text(text):
	messages_from_server.text = "[font_size={45}]" + text + "[/font_size]"
