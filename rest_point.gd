class_name RestPoint
extends Marker2D

@export var battlefield_id: int
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sprite_2d.get_rect().has_point(to_local(event.position)):
			print('rest point clicked!')
			SignalBus.rest_point_clicked.emit(self)


func highlight(onOff: bool):
	if onOff:
		sprite_2d.modulate = Color.WHITE
	else:
		sprite_2d.modulate = Color.BLACK
