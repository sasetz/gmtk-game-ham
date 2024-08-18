extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible=false
	$Weather_timer.wait_time=5.0
	$Weather_timer.timeout.connect(_new_weather_timeout)
	$Weather_timer.start()
	pass # Replace with function body.

func _new_weather_timeout():
	print("check")
	match randi_range(1,2):
		1:
			match randi_range(1,2):
				1:
					flip_h=true
				2:
					flip_h=false
			visible=true
			play("default")
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		2:
			stop()
			visible=false
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
