extends Enemy

func _ready():
	super._ready()
	TOWER_DAMAGE=12
	DAMAGE=0
	LIFE_TIME=15
	self.VERTICALSPEED = 130
	self.SPEED=130

func _on_mob_collided(entity: Node2D):
	if not entity.is_in_group("friend"):
		return
	var mob = entity as MobNPC
	if weath.type == "Moon":
		var new_enemy = ZombifiedFriendScene.instantiate()
		new_enemy.position = mob.position
		new_enemy.DIRECTION = mob.DIRECTION
		new_enemy.scale.x = mob.scale.x
		get_tree().current_scene.add_child(new_enemy)
		mob.die()
	else:
		print("kill")
		$AnimatedSprite2D.play("attack")
		mob.die()
		
func wall_check():
	if is_on_wall():
		velocity.y = -VERTICALSPEED*0.5
		$AnimatedSprite2D.play("default")
