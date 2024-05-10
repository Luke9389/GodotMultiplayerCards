extends Node2D
@onready var rest_point_1: RestPoint = $RestPoint
@onready var rest_point_2: RestPoint = $RestPoint2
@onready var rest_point_3: RestPoint = $RestPoint3
@onready var rest_point_4: RestPoint = $RestPoint4
@onready var rest_point_5: RestPoint = $RestPoint5
@onready var rest_point_6: RestPoint = $RestPoint6
@onready var rest_point_7: RestPoint = $RestPoint7
@onready var rest_point_8: RestPoint = $RestPoint8
@onready var rest_point_9: RestPoint = $RestPoint9

@onready var card_1: Card = $Card
@onready var card_2: Card = $Card2
@onready var card_3: Card = $Card3
@onready var card_4: Card = $Card4
@onready var card_5: Card = $Card5
@onready var card_6: Card = $Card6
@onready var card_7: Card = $Card7
@onready var card_8: Card = $Card8
@onready var card_9: Card = $Card9
@onready var card_10: Card = $Card10


# -- Game Flow --
# Tell server about click
# Wait for server to run target command
# Highlight based on server response
# Wait for user click
# Tell server about click
# Wait for server response
# Do thing based on server response

var selected_card: Card = null

@onready var all_cards := [
	card_1,
	card_2,
	card_3,
	card_4,
	card_5,
	card_6,
	card_7,
	card_8,
	card_9,
	card_10,
]

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
	SignalBus.set_up_player_two.connect(self.tell_player_two_to_set_up)

func handle_card_click(card: Card):
	# Tell server about click
	_server_handle_card_click.rpc(var_to_str(card))

func handle_rest_point_click(rest_point: RestPoint):
	# Tell server about click
	print(rest_point.battlefield_id)
	_server_handle_rest_point_click.rpc(var_to_str(rest_point))


@rpc("any_peer")
func _server_handle_card_click(card_string: String):
	if !multiplayer.is_server():
		return
	
	var card = str_to_var(card_string)
	# Run Target Command
	if var_to_str(selected_card) == card_string:
		highlight_rest_points.rpc('off')
		selected_card = null
		return
	
	selected_card = card
	if selected_card.fighter_type == Card.FighterType.SOLDIER:
		highlight_rest_points.rpc('center')
	if selected_card.fighter_type == Card.FighterType.BRUTE:
		highlight_rest_points.rpc('cross')
	if selected_card.fighter_type == Card.FighterType.HUNTER:
		highlight_rest_points.rpc('corners')


@rpc("any_peer")
func _server_handle_rest_point_click(rest_point_string: String):
	if !multiplayer.is_server():
		return
	
	var rest_point := str_to_var(rest_point_string) as RestPoint
	var rest_point_id = rest_point.battlefield_id

	if selected_card:
		move_card_to_rest_point.rpc(selected_card.id, rest_point_id)
		selected_card = null

@rpc("authority")
func highlight_rest_points(pattern: String):
	for rest_point in all_rest_points:
		rest_point.highlight(false)
	
	var all_points = rest_point_patterns[pattern]
	for rest_point in all_points:
		rest_point.highlight(true)


@rpc("authority")
func move_card_to_rest_point(card_id: int, rest_point_id: int):
	var card = all_cards[card_id - 1]
	var rest_point = find_rest_point(rest_point_id)
	print('Moving card: ' + str(card_id) + ' to RestPoint: ' + str(rest_point_id))

	card.modulate = Color.BLUE
	rest_point.modulate = Color.BLUE
	var movement_tween := get_tree().create_tween()
	movement_tween.tween_property(card, 'global_position', rest_point.global_position, 0.4)

func find_rest_point(id: int) -> RestPoint:
	return all_rest_points.filter(
		func(rp) -> bool:
			return rp.battlefield_id == id
	)[0]

func tell_player_two_to_set_up(id: int):
	set_up_as_player_two.rpc_id(id)

@rpc("authority")
func set_up_as_player_two():
	# Remap rest points	
	for rest_point in all_rest_points:
		var old_id = rest_point.battlefield_id
		rest_point.battlefield_id = 10 - old_id
	
	for card in all_cards:
		card.global_position.x = 1080 - card.global_position.x
		if card.global_position.y > 1000:
			card.global_position.y = 575
		elif card.global_position.y < 1000:
			card.global_position.y = 1700
