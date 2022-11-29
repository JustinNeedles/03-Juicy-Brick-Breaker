extends KinematicBody2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02
var xScale = 1.2
var yScale = .6

var fastspeed = 2000
var minspeed = 1000

var moving = false

func _ready():
	width = $CollisionShape2D.get_shape().get_extents().x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	var difference = abs(position.x - target.x)
	
	if position != target:
		$Tween.remove_all()
		$Tween.interpolate_property($Node2D, "scale", $Node2D.scale, Vector2(1, 1) + Vector2(xScale - 1, yScale - 1) * clamp((difference / delta - minspeed) / fastspeed , 0, 1), .02, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		moving = true
	else:
		if moving:
			$Tween.remove_all()
			$Tween.interpolate_property($Node2D, "scale", $Node2D.scale, Vector2(1, 1), .005, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		moving = false
	position = target

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x
