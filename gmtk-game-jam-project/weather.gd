extends AnimatedSprite2D
class_name Weather
@export var type:String
@export var background2:CompressedTexture2D=preload("res://Visual/Screens/Задник дождь или снег.png")
@export var background1:CompressedTexture2D=preload("res://Visual/Backgrounds/Задник.png")
@export var background3:CompressedTexture2D=preload("res://Visual/Screens/Задник красная луна.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	visible=false
	type="None"
	$Weather_timer.wait_time=5.0
	$Weather_timer.timeout.connect(_new_weather_timeout)
	$Weather_timer.start()
	pass # Replace with function body.

func _new_weather_timeout():
	match randi_range(1,14):
		1,9:
			if not visible:
				match randi_range(1,2):
					1:
						flip_h=true
						type="Wind2"
					2:
						type="Wind1"
						flip_h=false
			visible=true
			play("Ветер")
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		2,3,10,11,12,13,14:
			play("Nothing")
			type="None"
			visible=false
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
		4:
			type="Rain"
			visible=true
			play("Дождь")
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		5:
			type="Snow"
			visible=true
			play("Снег")
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		6:
			type="Smoke"
			visible=true
			
			play("Туман")
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		7:
			type="Moon"
			visible=true
			play("Nothing")
			$"../UI/Background".texture=background3
			$Weather_timer.wait_time=20.0
			$Weather_timer.start()
		8:
			type="Meteor"
			print(type)
			play("Nothing")
			visible=true
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
