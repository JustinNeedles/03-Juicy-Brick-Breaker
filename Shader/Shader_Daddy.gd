extends Node2D


var mouseposition = Vector2.ZERO

onready var Shade = load("res://Shader/CanvasShader.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		var shader = Shade.instance()
		add_child(shader)
		mouseposition = get_viewport().get_mouse_position()
		shader.get_child(0).material.set_shader_param("origin", mouseposition / 1024.0)
		print(get_child_count())
