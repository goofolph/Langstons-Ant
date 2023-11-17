extends CharacterBody2D

var tile_size = 16
var tilesHorizontal
var tilesVerticle
var gridPos = Vector2(27,16)

var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}
var direction = Vector2.UP
var rules = {
	"turns": [
		random_dir(),
		random_dir(),
		random_dir(),
		random_dir(),
		random_dir(),
		random_dir(),
		random_dir(),
		random_dir(),
	],
	"tiles": [0,1,2,3,4,5,6,7]
}

func random_dir():
	match (randi()% 3):
		0:
			return "left"
		1:
			return "right"
		2:
			return "forward"
		_:
			return "reverse"

func _ready():
	tilesHorizontal = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_size
	tilesVerticle = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_size
	
	rules["tiles"].shuffle()
	
	
	gridPos = Vector2(tilesHorizontal/ 2,tilesVerticle/2)
	position = gridPos * tile_size
	print(position)
	position += Vector2.ONE * tile_size/2

func turn_left():
	match direction:
		Vector2.UP:
			direction = Vector2.LEFT
		Vector2.DOWN:
			direction = Vector2.RIGHT
		Vector2.LEFT:
			direction = Vector2.DOWN
		Vector2.RIGHT:
			direction = Vector2.UP
			
func turn_right():
	match direction:
		Vector2.UP:
			direction = Vector2.RIGHT
		Vector2.DOWN:
			direction = Vector2.LEFT
		Vector2.LEFT:
			direction = Vector2.UP
		Vector2.RIGHT:
			direction = Vector2.DOWN

func turn(dir):
	match dir:
		"left":
			turn_left()
		"right":
			turn_right()
		"reverse":
			turn_left()
			turn_left()

func _process(delta):
	var tMap = get_tree().get_current_scene().get_node("TileMap")
	var tile = tMap.get_cell_source_id(0, gridPos)

	print(rules["tiles"][tile])
	turn(rules["turns"][tile])
	tMap.set_cell(0, gridPos, rules["tiles"][tile], Vector2(0,0), 0)

	gridPos += direction

	if gridPos[0] < 0:
		gridPos[0] = tilesHorizontal - 1
	elif gridPos[0] >= tilesHorizontal:
		gridPos[0] = 0
	if gridPos[1] < 0:
		gridPos[1] = tilesVerticle - 1
	elif gridPos[1] >= tilesVerticle:
		gridPos[1] = 0

	position = tMap.map_to_local(gridPos)
