extends RigidBody2D


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
