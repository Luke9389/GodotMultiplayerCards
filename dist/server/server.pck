GDPC                P                                                                         T   res://.godot/exported/1835728624/export-218a8f2b3041327d8a5756f3a245f83b-icon.res   @      '      �n�j��4�D?��    T   res://.godot/exported/1835728624/export-6455994a605b35b7d96f8362f3055c4a-Game.scn   �      �      3���+
?����"��    T   res://.godot/exported/1835728624/export-93687ce295c5439b548dba5c17b5aa0b-Card.scn   p#      �      ��OF�?�L����ƙ�    X   res://.godot/exported/1835728624/export-963b935435c587d4fd75e1ff5de7d9d8-SignalBus.scn  �(      p      2���|�t��=m��Ǩ_    X   res://.godot/exported/1835728624/export-e0fb25051f44b1b2811a545bcbc8c732-RestPoint.scn  @-      �      т:�K���m_�    ,   res://.godot/global_script_class_cache.cfg  �2      �       쯩�}Z����g y���       res://.godot/uid_cache.bin  `7      �       ���N�c{���QNN	#�       res://Card.tscn.remap   P1      b       =�V�`3�l��d       res://Game.tscn.remap   �0      b       p.�����n��w3�       res://RestPoint.tscn.remap  02      g       ўwsvN�.נC���       res://SignalBus.tscn.remap  �1      g       K��XP��Q�x���       res://battlefield.gdp      �      �.X�9B]!�y�]�       res://card.gd   p&      =      �	t��,�h��#�{8P�       res://game.gd           �      B�V���>Q6�y
y�r       res://icon.svg  �3      �      C��=U���^Qu��U3       res://icon.svg.import   p      �       �l*bj�q
��ɝ��       res://project.binary 8      �      �P�zRr��,`3�e�gO       res://rest_point.gd  +      �      .�|ͥP7+�Xb��       res://signal_bus.gd �,      _       ���m��*꒭7�    extends Node2D

var IP_ADDRESS := "3.144.198.65"
var PORT_NUMBER := 8080
var message_count_from_client := 0

var connection_status

@onready var status_text = $Panel/VBoxContainer/Status
@onready var messages_from_server: RichTextLabel = $Panel/VBoxContainer/MessagesFromServer


func _ready() -> void:
	# Pull cli arguments from build
	var args = Array(OS.get_cmdline_args())
	print("args: " + str(args))
	
	if OS.has_feature('dedicated_server'):
		print("loading server...")
		start_server()
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


func _process(_delta: float) -> void:
	
	var new_status = multiplayer.multiplayer_peer.get_connection_status()
	if new_status != connection_status:
		connection_status = new_status
		print(new_status)
	

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
      RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    size    script 	   _bundled       Script    res://game.gd ��������   Script    res://battlefield.gd ��������   PackedScene    res://RestPoint.tscn T�����A?   PackedScene    res://Card.tscn �	I�H5�#   #   local://PlaceholderTexture2D_nleml �      #   local://PlaceholderTexture2D_h3rep �      #   local://PlaceholderTexture2D_6vvus �      #   local://PlaceholderTexture2D_bk6nm !      #   local://PlaceholderTexture2D_t06ml V         local://PackedScene_c6ri2 �         PlaceholderTexture2D       
      C   C         PlaceholderTexture2D       
      C   C         PlaceholderTexture2D       
      C   C         PlaceholderTexture2D       
      C   C         PlaceholderTexture2D       
      C   C         PackedScene          	         names "   ,      Game    script    Node2D    Panel    offset_left    offset_top    offset_right    offset_bottom    VBoxContainer    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Status    size_flags_vertical    bbcode_enabled    RichTextLabel    MessagesFromServer    SendMessage    text    Button    Battlefield 
   RestPoint 	   position    RestPoint2    RestPoint3    RestPoint4    RestPoint5    RestPoint6    RestPoint7    RestPoint8    RestPoint9    Card    texture    fighter_type    metadata/_edit_group_    Card2    Card3    Card4    Card5    _send_message_to_server    pressed    	   variants    "                  �A     �A     �D    ��C                 �?                        SEND MESSAGE                   
     vC ��D
    �D ��D
     TD `�D
     rC �sD
    �D �sD
    �SD @tD
     pC  *D
    @D @*D
    �RD �*D         
     bC ��D          
    ��C ��D         
    �D  �D         
    �5D  �D         
    �^D  �D               node_count             nodes     �   ��������       ����                            ����                                            ����   	      
                                               ����   	         	      
                    ����   	         	      
                    ����   	         	                           ����                    ���                          ���                          ���                          ���                          ���                          ���                          ���                          ���                           ���!                          ���"               #      $      %   
              ���&               #      %   
              ���'               #      $      %   
              ���(               #      $      %   
              ���)                #   !   %   
             conn_count             conns               +   *                    node_paths              editable_instances              version             RSRC  [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://iyh30hlppwue"
metadata={
"vram_texture": false
}
path="res://.godot/exported/1835728624/export-218a8f2b3041327d8a5756f3a245f83b-icon.res"
   RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_ik1bo �          PlaceholderTexture2D       
      C   C      RSRC         extends Node2D
@onready var rest_point_1: RestPoint = $RestPoint
@onready var rest_point_2: RestPoint = $RestPoint2
@onready var rest_point_3: RestPoint = $RestPoint3
@onready var rest_point_4: RestPoint = $RestPoint4
@onready var rest_point_5: RestPoint = $RestPoint5
@onready var rest_point_6: RestPoint = $RestPoint6
@onready var rest_point_7: RestPoint = $RestPoint7
@onready var rest_point_8: RestPoint = $RestPoint8
@onready var rest_point_9: RestPoint = $RestPoint9

# -- Game Flow --
# Tell server about click
# Wait for server to run target command
# Highlight based on server response
# Wait for user click
# Tell server about click
# Wait for server response
# Do thing based on server response

var selected_card: Card = null

@onready var all_rest_points := [
	rest_point_1,
	rest_point_2,
	rest_point_3,
	rest_point_4,
	rest_point_5,
	rest_point_6,
	rest_point_7,
	rest_point_8,
	rest_point_9
]
@onready var rest_point_patterns := {
	'off': [],
	'center': [rest_point_5],
	'corners': [rest_point_1, rest_point_3, rest_point_7, rest_point_9],
	'cross': [rest_point_2, rest_point_4, rest_point_6, rest_point_8]
}

func _ready() -> void:
	SignalBus.card_clicked.connect(self.handle_card_click)
	SignalBus.rest_point_clicked.connect(self.handle_rest_point_click)


func handle_card_click(card: Card):
	# Tell server about click
	_server_handle_card_click.rpc(var_to_str(card))

func handle_rest_point_click(rest_point: RestPoint):
	# Tell server about click
	pass


@rpc("any_peer")
func _server_handle_card_click(card_string: String):
	if !multiplayer.is_server():
		return
	
	var card = str_to_var(card_string)
	# Run Target Command
	if var_to_str(selected_card) ==\
		var_to_str(card):
		highlight_rest_points.rpc('off')
	
	selected_card = card
	if selected_card.fighter_type == Card.FighterType.SOLDIER:
		highlight_rest_points.rpc('center')
	if selected_card.fighter_type == Card.FighterType.BRUTE:
		highlight_rest_points.rpc('cross')
	if selected_card.fighter_type == Card.FighterType.HUNTER:
		highlight_rest_points.rpc('corners')


@rpc("authority")
func highlight_rest_points(pattern: String):
	for rest_point in all_rest_points:
		rest_point.highlight(false)
	
	var all_points = rest_point_patterns[pattern]
	for rest_point in all_points:
		rest_point.highlight(true)
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    size    script 	   _bundled       Script    res://card.gd ��������   #   local://PlaceholderTexture2D_wongr =         local://PackedScene_xkv38 r         PlaceholderTexture2D       
      C   C         PackedScene          	         names "         Card    texture    script 	   Sprite2D    	   variants                                 node_count             nodes        ��������       ����                          conn_count              conns               node_paths              editable_instances              version             RSRC          class_name Card
extends Sprite2D

enum FighterType { SOLDIER, HUNTER, BRUTE }
@export var fighter_type := FighterType.SOLDIER

func _ready() -> void:
	if fighter_type == FighterType.SOLDIER:
		self.modulate = Color.MAGENTA
	if fighter_type == FighterType.BRUTE:
		self.modulate = Color.CYAN
	if fighter_type == FighterType.HUNTER:
		self.modulate = Color.YELLOW


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			SignalBus.card_clicked.emit(self)

   RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://signal_bus.gd ��������      local://PackedScene_nflue          PackedScene          	         names "      
   SignalBus    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRCclass_name RestPoint
extends Marker2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sprite_2d.get_rect().has_point(to_local(event.position)):
			SignalBus.rest_point_clicked.emit(self)


func highlight(onOff: bool):
	print('hello!')
	if onOff:
		sprite_2d.modulate = Color.WHITE
	else:
		sprite_2d.modulate = Color.BLACK
  extends Node

signal card_clicked(card: Card)
signal rest_point_clicked(rest_point: RestPoint)
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    size    script 	   _bundled       Script    res://rest_point.gd ��������   #   local://PlaceholderTexture2D_bywhi C         local://PackedScene_atdl5 x         PlaceholderTexture2D       
      C   C         PackedScene          	         names "      
   RestPoint    script 	   Marker2D 	   Sprite2D 	   modulate    texture_filter    scale    texture    	   variants                                  �?      
     �?  �?                node_count             nodes        ��������       ����                            ����                                     conn_count              conns               node_paths              editable_instances              version             RSRC            [remap]

path="res://.godot/exported/1835728624/export-6455994a605b35b7d96f8362f3055c4a-Game.scn"
              [remap]

path="res://.godot/exported/1835728624/export-93687ce295c5439b548dba5c17b5aa0b-Card.scn"
              [remap]

path="res://.godot/exported/1835728624/export-963b935435c587d4fd75e1ff5de7d9d8-SignalBus.scn"
         [remap]

path="res://.godot/exported/1835728624/export-e0fb25051f44b1b2811a545bcbc8c732-RestPoint.scn"
         list=Array[Dictionary]([{
"base": &"Sprite2D",
"class": &"Card",
"icon": "",
"language": &"GDScript",
"path": "res://card.gd"
}, {
"base": &"Marker2D",
"class": &"RestPoint",
"icon": "",
"language": &"GDScript",
"path": "res://rest_point.gd"
}])
          <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             ��uN9�{   res://Game.tscn�	�B�|   res://icon.svgT�����A?   res://RestPoint.tscn�	I�H5�#   res://Card.tscn{Z|$1��L   res://SignalBus.tscn            ECFG      _custom_features         dedicated_server   application/config/name         GudnakMultiplayer      application/run/main_scene         res://Game.tscn    application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg     autoload/SignalBus          *res://SignalBus.tscn   "   display/window/size/viewport_width      8  #   display/window/size/viewport_height      �        