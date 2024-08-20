extends Area2D
class_name Dragon

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_active)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func breath():
	$AnimatedSprite2D.play("default")
	$Timer.wait_time=1.0
	$Timer.start()
	
func _active():
	monitoring=true

func _on_body_entered(bod):
	for body in get_overlapping_bodies():
		if (body is MobNPC):
			body.die()
		elif (body is BuildingStructure):
			body.current_health -= int(200)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
	pass # Replace with function body.
