extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time 

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0

func _physics_process(delta):
	time += delta
	get_child(0).material.set_shader_param("tim", time)
	
	if time > 2:
		queue_free()
