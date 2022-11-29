extends StaticBody2D

var new_position = Vector2.ZERO
var dying = false
var color = Color(1, 1, 1, 1)

var change = true

func _ready():
	randomize()
	randColor()
	$Area2D.collision_layer = 0
	position = new_position

func _physics_process(_delta):
	if change:
		$Tween.interpolate_property($ColorRect, "color", $ColorRect.color, color,
		1 + rand_range(0, 1), Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$Tween.start()
		change = false
	if dying:
		queue_free()

func hit(_ball):
	if $Area2D.collision_layer == 1:
		var normal = Vector3(color.r, color.g, color.b).normalized() * 2
		get_node("/root/Game/Shader").hit(position, 2, Color(normal.x, normal.y, normal.z, 1), 2)
	die()

func fragile():
	collision_layer = 0
	$Area2D.collision_layer = 1

func strong():
	collision_layer = 1
	$Area2D.collision_layer = 0

func die():
	dying = true
	collision_layer = 0
	$Area2D.collision_layer = 0
	$ColorRect.hide()
	get_parent().check_level()


func _on_Area2D_body_entered(body):
	if "Ball" in body.name:
		hit(body)

func randColor():
	var sat = Color(0, 0, 0, 1)
	sat = Vector3(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)). normalized()
	color = Color(clamp(sat.x, 0, 1), clamp(sat.y, 0, 1), clamp(sat.z, 0, 1), 1)

func _on_Tween_tween_completed(_object, _key):
	randColor()
	change = true
