extends Enemy

func _ready():
	super._ready()
	TOWER_DAMAGE=50
	DAMAGE=5
	LIFE_TIME=20
	self.VERTICALSPEED = 0
	self.SPEED=80
	HEALTH=3
	
func wall_check():
	if is_on_wall():
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("default")
