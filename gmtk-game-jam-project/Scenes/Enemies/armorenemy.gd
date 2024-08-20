extends Enemy


func _ready():
	super._ready()
	TOWER_DAMAGE=30
	health=4
	LIFE_TIME=40
	self.VERTICALSPEED = 60
	self.SPEED=60
	$AnimatedSprite2D.play("default")
