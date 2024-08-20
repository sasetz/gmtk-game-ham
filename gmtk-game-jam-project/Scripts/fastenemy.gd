extends Enemy

func _ready():
	super._ready()
	TOWER_DAMAGE=22
	LIFE_TIME=8
	self.VERTICALSPEED = 500
	self.SPEED=200
