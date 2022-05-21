extends Control

var radius = 16
var color = Color.white

func _ready():
	Events.connect("set_area_of_effect", self, "_on_set_area_of_effect")

func _process(delta):
	if not visible: return
	update()

func _on_set_area_of_effect(is_visible, radius, color):
	visible = is_visible
	self.radius = radius
	self.color = color
	print(radius)

func _draw():
	draw_circle(get_local_mouse_position(), radius, color)
