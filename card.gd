class_name Card
extends Sprite2D

enum FighterType { SOLDIER, HUNTER, BRUTE }
@export var fighter_type := FighterType.SOLDIER
@export var id := 0

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

