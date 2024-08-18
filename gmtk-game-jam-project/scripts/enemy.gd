extends MobNPC
class_name Enemy


func _ready():
	super._ready()
	TOWER_DAMAGE=25
	LIFE_TIME=8
	self.VERTICALSPEED = 600
	self.SPEED=200
