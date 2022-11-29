extends Node2D

onready var Shade = load("res://Shader/CanvasShader.tscn")

var zoom = 1

func hit(position, intensity, color = Color(1, 1, 1, 1), speed = 1.2):
	var shader = Shade.instance()
	add_child(shader)
	shader.get_child(0).material.set_shader_param("origin", position / 1024.0)
	shader.get_child(0).material.set_shader_param("intensity", intensity)
	shader.get_child(0).material.set_shader_param("color", color)
	shader.get_child(0).material.set_shader_param("speed", speed)

