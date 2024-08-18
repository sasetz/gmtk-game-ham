extends Node2D

@onready var inventory := $Inventory


func _ready() -> void:
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

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1"):
		inventory.release_item()
