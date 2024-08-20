extends Node2D

enum MapMode {
	Story,
	Debug,
}

@onready var inventory := $Inventory
@onready var spawner := $Spawner
@export var Mode := MapMode.Story


func _ready() -> void:
	match Mode:
		MapMode.Story:
			pass
		MapMode.Debug:
			pass

func _process(_delta: float) -> void:
	if Input.is_action_just_released("MWU"):
		inventory.scale_up()
	if Input.is_action_just_released("MWD"):
		inventory.scale_down()
	if Input.is_action_pressed("right"):
		inventory.rotate_clockwise()
	if Input.is_action_pressed("left"):
		inventory.rotate_counter()
	
	for i in range(1, 10):
		if Input.is_action_just_pressed(str(i)):
			inventory.select_item(i - 1)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1"):
		inventory.release_item()
