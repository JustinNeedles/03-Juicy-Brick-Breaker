extends RigidBody2D

var min_speed = 100.0
var max_speed = 900.0
var speed_multiplier = 1.0
var accelerate = false

var velocity = Vector2.ZERO
var time = 0
var min_time = 0.1
var rotationspeed = 7
var ragerot = rotationspeed * 2
var released = true
var rage = false

var deathCount = 0
var free = true
var free2 = false

var storeVel = Vector2.ZERO

var initial_velocity = Vector2.ZERO

func _ready():
	contact_monitor = true
	contacts_reported = 8
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		var level = Levels.levels[Global.level]
		min_speed *= level["multiplier"]
		max_speed *= level["multiplier"]
	

func _on_Ball_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
		if "Brick" in body.name:
			var intensity = velocity.length() / (max_speed * speed_multiplier) * pow(clamp(time * 2, 0, 1), 2) / 2
			time = 0
			get_node("/root/Game/Shader").hit(position, intensity, Color(1, 1, 1, 1))
		else:
			accelerate = true	

func _input(event):
	if not released and event.is_action_pressed("release"):
		apply_central_impulse(initial_velocity)
		released = true

func _physics_process(delta):
	var temp = rotationspeed
	if velocity.length() >= max_speed * speed_multiplier or rage:
		temp = ragerot
		if not rage:
			get_node("/root/Game/Camera2D").change = true
			get_node("/root/Game/Shader").hit(position, 10, Color(1, 0, 0, 1))
			rage = true
		get_node("/root/Game/Brick_Container").weaken()
		$Node2D/ColorRect.color = Color(1,0,0,1)
	else:
		get_node("/root/Game/Brick_Container").restore()
		if storeVel != velocity:
			$Tween.remove_all()
			$Tween.interpolate_property($Node2D/ColorRect, "color", $Node2D/ColorRect.color, Color(1, 1 - (velocity.length() - initial_velocity.length()) / (max_speed * speed_multiplier - initial_velocity.length()),
			 1 - (velocity.length() - initial_velocity.length()) / (max_speed * speed_multiplier - initial_velocity.length()), 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
			$Tween.start()
			storeVel = velocity
	
	$Node2D.rotation_degrees += temp * velocity.length() / (max_speed * speed_multiplier)
	get_node("/root/Game/UI/HUD").rotation = temp * velocity.length() / (max_speed * speed_multiplier)
	get_node("/root/Game/UI/HUD").color = $Node2D/ColorRect.color
	time += delta

func _integrate_forces(state):
	if not released:
		var paddle = get_node_or_null("/root/Game/Paddle_Container/Paddle")
		if paddle != null:
			state.transform.origin = Vector2(paddle.position.x + paddle.width, paddle.position.y - 30)	

	if position.y > Global.VP.y + 100:
		die()
	if accelerate:
		var acc = 1.05
		if rage:
			acc = 2.00
		state.linear_velocity = state.linear_velocity * acc
		accelerate = false
	if abs(state.linear_velocity.x) < min_speed * speed_multiplier:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed * speed_multiplier
	if abs(state.linear_velocity.y) < min_speed * speed_multiplier:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed * speed_multiplier
	if state.linear_velocity.length() > max_speed * speed_multiplier:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed * speed_multiplier
	
	velocity = state.linear_velocity

func change_speed(s):
	speed_multiplier = s

func die():
	sleeping = true
	if free:
		get_node("/root/Game/Shader").hit(position, 5, Color(1, 0, 0, 1))
		$Timer.start()
		free = false
		deathCount += 1
	if deathCount >= 3:
		queue_free()


func _on_Timer_timeout():
	free = true
	print(false)
