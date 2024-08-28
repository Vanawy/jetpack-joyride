extends Node
class_name ScoreManager

var score = 0
var pb_score = 0

func _ready():
	load_pb()
	
func update_score(new_score: int):
	score = new_score
	if score > pb_score:
		pb_score = score
		save_pb()
		
func save_pb():
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(str(pb_score))
	file.close()
	
func load_pb():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if !file:
		return
	var content = file.get_as_text()
	file.close()
	pb_score = int(content)
	print("pb: " + str(pb_score))
