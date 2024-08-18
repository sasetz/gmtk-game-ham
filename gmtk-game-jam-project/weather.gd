extends AnimatedSprite2D
class_name Weather
@export var wind:=0
# Called when the node enters the scene tree for the first time.
func _ready():
	visible=false
	wind=0
	$Weather_timer.wait_time=5.0
	$Weather_timer.timeout.connect(_new_weather_timeout)
	$Weather_timer.start()
	pass # Replace with function body.

func _new_weather_timeout():
	print("check")
	match randi_range(1,2):
		1:
			if not visible:
				match randi_range(1,2):
					1:
						flip_h=true
						wind=2
					2:
						wind=1
						flip_h=false
			visible=true
			play("default")
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		2:
			stop()
			wind=0
			visible=false
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
