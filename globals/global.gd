extends Node

var file_path = "user://leaderboards.json" 

@onready var leaderboards: Array = load_data()


func update_leaderboards(new_entry: Dictionary):
	leaderboards.append(new_entry)
	leaderboards.sort_custom(sort_descending)
	if leaderboards.size() > 10:
		leaderboards.resize(10)
	save_data()


func save_data():
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_text = JSON.stringify(leaderboards) 
		file.store_string(json_text)
		file.close()
		#print("Data saved to:", file_path)
	else:
		print("Failed to open file for writing")


func load_data():
	if not FileAccess.file_exists(file_path):
		print("No save file found at:", file_path)
		return []
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	var result = JSON.parse_string(json_text)
	if typeof(result) == TYPE_ARRAY:
		#print("Data loaded successfully")
		return result
	else:
		print("Failed to parse data (not an array)")
		return []


static func sort_descending(a, b):
	if int(a["Score"]) > int(b["Score"]):
		return true
	return false
