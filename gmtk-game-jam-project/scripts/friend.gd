extends MobNPC

func _ready():
	super._ready()
	LIFE_TIME=15
	if randi_range(1,3)==1:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("new_animation")
		
func dir_check():
	if DIRECTION:
		velocity.x = DIRECTION * (SPEED+tower.SPEED_UPGRADE)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED+tower.SPEED_UPGRADE))
		
func wall_check():
	if is_on_wall():
		velocity.y = -(VERTICALSPEED+tower.SPEED_UPGRADE)*0.5

func die():
	super.die()
	$AudioStreamPlayer.play()
	
