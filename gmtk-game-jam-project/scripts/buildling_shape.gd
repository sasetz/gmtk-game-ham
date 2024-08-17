extends RigidBody2D
class_name BuildingShape


@export var INITIAL_HEALTH := 30

var current_health := INITIAL_HEALTH:
	set(value):
		if value <= 0:
			print("Shape destroying now!")
			queue_free()
		current_health = value

var has_collision := true :
	set(value):
		freeze = not value
		if Collision:
			Collision.disabled = not value

		has_collision = value

@onready var Collision = $Collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Collision.disabled = not has_collision
	freeze = not has_collision

