class_name GameSettings

enum TowerTier {
	Small,
	Medium,
	Large,
}

# randi_range(data[level][0], data[level][1])
func get_friendly_batch(_level: int) -> int:
    return 0

# randi_range(data[level][2], data[level][3])
func get_enemy_batch(_level: int) -> int:
    return 0

# randi_range(1, data[level][4] + data[level][5]) <= data[level][5]
func should_spawn_enemy(_level: int) -> bool:
    return false

# data[level][6]
func get_spawner_wait_time(_level: int) -> float:
    return 0.0

# returns an array of what tower parts are available at the current level
func get_tower_parts(_level: int) -> Array:
    return []

# returns the whole list of items that are available at the current level
func get_item_roster(_level: int) -> Array:
    return []

# returns the whole list of enemies that can spawn at the current level
func get_enemy_pool(_level: int) -> Array:
    return []

# returns the whole list of weather conditions that can occur at the current level
func get_weather_pool(_level: int) -> Array:
    return []

# what preset of viewpoint is used
func get_tower_tier(_level: int) -> TowerTier:
    return TowerTier.Small

func get_people_requirement(_level: int) -> int:
    return 1

func reached_last_level(_level: int) -> bool:
    return false
