extends Camera2D


var change = false
var follow = false
var process = false

func _physics_process(delta):
	if change:
		if get_node("/root/Game/Ball_Container/Ball") != null and not process:
			for i in get_node("/root/Game/Shader").get_children():
				i.visible = false
			process = true
			Engine.time_scale = 0.02
			$Tween.interpolate_property(self, "position", position, get_node("/root/Game/Ball_Container/Ball").position, 0.02, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.interpolate_property(self, "zoom", zoom, Vector2(0.2, 0.2), 0.02, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.start()
	else: 
		position = Vector2(512, 400)
		zoom = Vector2.ONE
	if follow and get_node("/root/Game/Ball_Container/Ball") != null:
		$Tween2.interpolate_property(self, "position", position, get_node("/root/Game/Ball_Container/Ball").position, 0.01, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween2.start()
		zoom = Vector2(0.2, 0.2)

func _on_Tween_tween_completed(object, key):
	follow = true
	$Timer.start()


func _on_Timer_timeout():
	follow = false
	change = false
	process = false
	for i in get_node("/root/Game/Shader").get_children():
		i.visible = true
	Engine.time_scale = 1
