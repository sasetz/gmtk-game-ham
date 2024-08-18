extends Node2D

@onready var inventory := $Inventory

var _inventory_giver_timer: Timer
@onready var _item_roster := [
	inventory.CUBE_ITEM,
	inventory.RAMP_ITEM,
	inventory.RESIZE_ITEM,
	inventory.ROTATE_ITEM,
	inventory.DELETE_ITEM,
]
var _next_roster_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_inventory_giver_timer = Timer.new()
	add_child(_inventory_giver_timer)
	_inventory_giver_timer.wait_time = 3
	_inventory_giver_timer.one_shot = false
	_inventory_giver_timer.start()
	_inventory_giver_timer.timeout.connect(func():
		inventory.add_item(_item_roster[_next_roster_index])
		_next_roster_index += 1
		_next_roster_index %= _item_roster.size() # restricts the index to only this array's size
	)
	inventory.add_item(inventory.RAMP_ITEM)
	inventory.add_item(inventory.CUBE_ITEM)

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
