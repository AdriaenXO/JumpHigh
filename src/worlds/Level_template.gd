extends Node2D

export var platform_length: int = 20
export var platforms_per_length: int = 10
export var platforms_per_tileset: int = 10
export var distance_between_platforms: int = 5
export var tiles_to_generate: int = 500
var starting_position: int = 3
var current_tileset_id: int = 0
var number_of_tilesets: int = 6
var tilesets_change_per_threshold: int = 1
var number_of_platforms_per_width: int = 40
var minimum_length_of_platforms: int = 1
var length_change_per_threshold: int = 1
var jump_length: int = 15
var max_floor: int = 0
var floors_to_lose: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var platforms = get_node("platforms")
# warning-ignore:integer_division
	var previous_platform_center: int = number_of_platforms_per_width / 2
	for platform_number in range(tiles_to_generate): 
		var x_start_of_platform: int = previous_platform_center - jump_length + randi() % (2 * jump_length + 1)  #calculate potential starting x of the platform
		#x_start_of_platform = max(x_start_of_platform, 0) #check if x is smaller than 0
		if (x_start_of_platform < 0):
# warning-ignore:narrowing_conversion
			x_start_of_platform = x_start_of_platform + jump_length * 1.5
		#x_start_of_platform = min(x_start_of_platform, number_of_platforms_per_width) #check if x is greater than number_of_platforms_per_width
		if (number_of_platforms_per_width - x_start_of_platform < platform_length):
			x_start_of_platform = number_of_platforms_per_width - platform_length
		var x_end_of_platform: int = x_start_of_platform + platform_length #calculate end point of the platform
# warning-ignore:integer_division
		var current_mid: int = (x_end_of_platform + x_start_of_platform) / 2
		var y_of_platform: int = starting_position + platform_number * distance_between_platforms #calculate y of the platform
		if(platform_number+1 == tiles_to_generate): #last platform
			for tile_number in range(number_of_platforms_per_width): #draw full line of tiles
				platforms.set_cell(tile_number, -y_of_platform, current_tileset_id)
		for tile_position_x in range(x_start_of_platform, x_end_of_platform): #generate tiles one by one
			platforms.set_cell(tile_position_x, -y_of_platform, current_tileset_id)
		if (platform_number % platforms_per_length == 0): #check if platforms_per_length have been generated
# warning-ignore:narrowing_conversion
			print("length before ", platform_length, " per length ", platforms_per_length)
			platform_length = max(platform_length - length_change_per_threshold, minimum_length_of_platforms)
			print(" after ", platform_length)
		if (platform_number % platforms_per_tileset == 0): #check if platforms_per_tileset have been generated
			current_tileset_id = (current_tileset_id + tilesets_change_per_threshold) % number_of_tilesets #change tileset to the next one
			for tile_number in range(number_of_platforms_per_width): #draw full line of tiles
				platforms.set_cell(tile_number, -y_of_platform, current_tileset_id)
# warning-ignore:integer_division
			current_mid = number_of_platforms_per_width / 2 #set middle point
			previous_platform_center = current_mid
			continue
		if (current_mid == 0):
			current_mid = x_start_of_platform
		previous_platform_center = current_mid
# warning-ignore:integer_division
		print("floor ", platform_number, " start ", x_start_of_platform, " end ", x_end_of_platform, " mid ", current_mid, " length ", platform_length)
	#platform_number is the same as -( -y_of_platform - starting_position - 1) / distance_between_platforms
	#print(platforms.tile_set.find_tile_by_name("tile-2.png 1"))
	#print(platforms.get_cell(17,-13))

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var platforms = get_node("platforms")
	var player_position = get_node("Player").get_global_position()
	var loc = platforms.world_to_map(player_position)
	var currentFloor = floor((-loc.y - starting_position - 1) / distance_between_platforms)
# warning-ignore:narrowing_conversion
	max_floor = max(max_floor, currentFloor)
	var currentFloorField = get_node("bottombar/currentFloorControl/currentFloorField")
	currentFloorField.set_text(str(currentFloor))
	var maxFloorField = get_node("bottombar/maxFloorControl/maxFloorField")
	maxFloorField.set_text(str(max_floor))
	get_node("wall_left/CollisionShape2D").position.y = player_position.y
	get_node("wall_right/CollisionShape2D").position.y = player_position.y
	if (currentFloor <= max_floor - floors_to_lose):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/worlds/GameLost.tscn")
	if (currentFloor == tiles_to_generate):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/worlds/GameWon.tscn")
