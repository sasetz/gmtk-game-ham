extends MobNPC
class_name Enemy


func _ready():
	super._ready()
	TOWER_DAMAGE=15
	LIFE_TIME=10
	self.VERTICALSPEED = 100
	self.SPEED=100
	$AnimatedSprite2D.play("default")
