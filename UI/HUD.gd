extends Control

var indicator_margin = Vector2(25, 15)
var indicator_index = 25
onready var Indicator = load("res://UI/Indicator.tscn")

var rotation = 0
var color = Color(1, 1, 1, 1)

func _ready():
	update_lives()


func update_lives():
	var indicator_pos = Vector2(indicator_margin.x, Global.VP.y - indicator_margin.y)
	for i in $Indicator_Container.get_children():
		i.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instance()
		indicator.position = Vector2(indicator_pos.x + i*indicator_index, indicator_pos.y)
		$Indicator_Container.add_child(indicator)
		
func _physics_process(_delta):
	for i in $Indicator_Container.get_children():
		i.rotation_degrees += rotation
		i.get_child(0).color = color
