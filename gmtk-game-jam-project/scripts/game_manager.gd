extends Node2D

@onready var inventory := $Inventory
@onready var spawner := $Spawner

var health: int
var max_health: int
var regeneration: float
var level: int
var saves: int


class StorySettings extends GameSettings:
	var data = [
		[2.0, 4.0, 1.0, 3.0, 1.0, 1.0, 4.0],
		[2.0, 4.0, 1.0, 3.0, 1.0, 1.0, 4.0],
		[2.0, 4.0, 2.0, 3.0, 3.0, 4.0, 3.9],
		[3.0, 5.0, 2.0, 4.0, 3.0, 4.0, 3.9],
		[3.0, 6.0, 2.0, 5.0, 2.0, 3.0, 3.9],
		[4.0, 7.0, 3.0, 5.0, 1.0, 2.0, 3.8],
		[4.0, 7.0, 3.0,	6.0, 1.0, 2.0, 3.8],
		[5.0, 8.0, 4.0, 7.0, 1.0, 2.0, 3.7],
		[6.0, 8.0, 5.0, 7.0, 1.0, 2.0, 3.6],
		[7.0, 8.0, 5.0, 7.0, 2.0, 5.0, 3.5],
		[5.0, 9.0, 6.0, 7.0, 1.0, 2.0, 3.4],
		[6.0, 9.0, 6.0, 7.0, 1.0, 2.0, 3.3],
		[5.0, 10.0, 5.0, 8.0, 2.0, 5.0, 3.2],
		[6.0, 10.0, 5.0, 9.0, 2.0, 5.0, 3.1],
		[6.0, 11.0, 6.0, 9.0, 2.0, 5.0, 3.0],
		[5.0, 12.0, 7.0, 10.0, 1.0, 3.0, 3.0]
	]
	var _tower_parts = [
		[Tower.TowerPart.InventoryUpgrade, Tower.TowerPart.SaveUpgrade], # 1-2 lvl
		[Tower.TowerPart.ArrowUpgrade, Tower.TowerPart.SaveUpgrade, Tower.TowerPart.RegenerationUpgrade], # 3 lvl
		[Tower.TowerPart.ArrowUpgrade, Tower.TowerPart.SaveUpgrade, Tower.TowerPart.RegenerationUpgrade,
		Tower.TowerPart.SpeedUpgrade], # 4-6 lvl
		[Tower.TowerPart.ArrowUpgrade, Tower.TowerPart.SaveUpgrade, Tower.TowerPart.RegenerationUpgrade,
		Tower.TowerPart.SpeedUpgrade, Tower.TowerPart.ArrowUpgrade], # 7+ lvl
	]
	var _items = [
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM], # 1-2 lvl
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM, Inventory.SQUARE_ITEM], # 3 lvl
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM, Inventory.SQUARE_ITEM, Inventory.RESIZE_ITEM], # 4 lvl
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM, Inventory.SQUARE_ITEM, Inventory.RESIZE_ITEM, Inventory.RAMP_ITEM], # 5 lvl
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM, Inventory.SQUARE_ITEM, Inventory.RESIZE_ITEM, Inventory.RAMP_ITEM,
		Inventory.CIRCLE_ITEM, Inventory.ROTATE_ITEM], # 6-7 lvl
		[Inventory.PENTA_ITEM, Inventory.CUBE_ITEM, Inventory.DELETE_ITEM, Inventory.SQUARE_ITEM, Inventory.RESIZE_ITEM, Inventory.RAMP_ITEM,
		Inventory.CIRCLE_ITEM, Inventory.ROTATE_ITEM, Inventory.EG_ITEM], # 8+ lvl
	]
	var _weather = [
		["Wind", "None", "None"], # 1-2 lvl
		["Wind", "None", "None", "Snow"], # 3-4 lvl
		["Wind", "None", "None", "Snow", "Rain"], # 5-7 lvl
		["Wind", "None", "None", "Snow", "Rain", "Smoke"], # 8-9 lvl
		["Wind", "None", "None", "Snow", "Rain", "Smoke", "Meteor"], # 10-11 lvl
		["Wind", "None", "None", "Snow", "Rain", "Smoke", "Meteor", "Moon"], # 12-13 lvl
		["Wind", "None", "None", "Snow", "Rain", "Smoke", "Meteor", "Moon", "Dragon"], # 14+ lvl
	]

	func _wrong(level: int) -> bool:
		return not (level < data.size() and level >= 0)

	func get_friendly_batch(level: int) -> int:
		if _wrong(level):
			level = -1
		return randi_range(data[level][0], data[level][1])

	func get_enemy_batch(level: int) -> int:
		if _wrong(level):
			level = -1
		return randi_range(data[level][2], data[level][3])
	
	func should_spawn_enemy(level: int) -> bool:
		if _wrong(level):
			level = -1
		return randi_range(1, data[level][4] + data[level][5]) <= data[level][5]
	
	func get_spawner_wait_time(level: int) -> float:
		if _wrong(level):
			level = -1
		return data[level][6]
	
	# returns an array of what tower parts are available at the current level
	func get_tower_parts(level: int) -> Array:
		if _wrong(level):
			return _tower_parts[-1]
		if level < 3:
			return _tower_parts[0]
		if level == 3:
			return _tower_parts[1]
		if level < 7:
			return _tower_parts[2]
		return _tower_parts[3]
	
	# returns the whole list of items that are available at the current level
	func get_item_roster(level: int) -> Array:
		if _wrong(level):
			level = -1
		if level < 3:
			return _items[0]
		if level == 3:
			return _items[1]
		if level == 4:
			return _items[2]
		if level == 5:
			return _items[3]
		if level < 8:
			return _items[4]
		return _items[5]
	
	# returns the whole list of enemies that can spawn at the current level

	
	# returns the whole list of weather conditions that can occur at the current level
	func get_weather_pool(level: int) -> Array:
		if _wrong(level):
			return _weather[-1]
		if level < 3:
			return _weather[0]
		if level < 5:
			return _weather[1]
		if level < 8:
			return _weather[2]
		if level < 10:
			return _weather[3]
		if level < 12:
			return _weather[4]
		if level < 14:
			return _weather[5]
		return _weather[6]
	
	# what preset of viewpoint is used
	func get_tower_tier(level: int) -> TowerTier:
		if _wrong(level):
			return TowerTier.Large
		elif level < 5:
			return TowerTier.Small
		elif level < 10:
			return TowerTier.Medium
		else:
			return TowerTier.Large
	
	func get_people_requirement(_level: int) -> int:
		return 5
	
	func reached_last_level(level: int) -> bool:
		return level >= 16



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
	
	for i in range(1, 10):
		if Input.is_action_just_pressed(str(i)):
			inventory.select_item(i - 1)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1"):
		inventory.release_item()
