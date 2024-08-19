extends BuildingStructure


# Called when the node enters the scene tree for the first time.
const SpeedToKill := 25.0
const Damage := 1
const SelfDamage := 5

func _on_death_collision_body_entered(body: Node2D) -> void:
	if not has_collision:
		return
	if not body.is_in_group("friend") and not body.is_in_group("enemy"):
		return
	
	if not (body is MobNPC):
		print ("This body is not a friend or enemy, but it's in their group! (Bug)")
		return
	
	var mob = body as MobNPC
	mob.health -= Damage
