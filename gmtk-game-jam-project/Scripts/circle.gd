extends BuildingStructure


const SpeedToKill := 25.0
const Damage := 1
const SelfDamage := 1

func _on_death_collision_body_entered(body: Node2D) -> void:
	if not has_collision:
		return
	if not body.is_in_group("friend") and not body.is_in_group("enemy"):
		return
	if linear_velocity.length() < SpeedToKill:
		return
	
	if not (body is MobNPC):
		print ("This body is not a friend or enemy, but it's in their group! (Bug)")
		return
	
	var mob = body as MobNPC
	mob.health -= Damage
	current_health -= SelfDamage
