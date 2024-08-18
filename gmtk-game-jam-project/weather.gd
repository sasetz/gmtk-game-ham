extends AnimatedSprite2D
class_name Weather
@export var type:String
# Called when the node enters the scene tree for the first time.
func _ready():
	visible=false
	type="None"
	$Weather_timer.wait_time=5.0
	$Weather_timer.timeout.connect(_new_weather_timeout)
	$Weather_timer.start()
	pass # Replace with function body.

func _new_weather_timeout():
	match randi_range(1,5):
		1:
			if not visible:
				match randi_range(1,2):
					1:
						flip_h=true
						type="Wind2"
					2:
						type="Wind1"
						flip_h=false
			visible=true
			play("default")
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		2,3,4:
			stop()
			type="None"
			visible=false
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
		5:
			type="Rain"
			visible=true
			print("RAIN")
			play("default")
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
