extends Node

onready var file = File.new()

func load_data(url):
	if url == null: return
	if !file.file_exists(url): return
	
	file.open(url, File.READ)
	
	var data_text = file.get_as_text()
	
	file.close()
	
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("Error on line " + str(data_parse.error_line) + " of " + url + ": " + data_parse.error_string)
		return
	
	var data = data_parse.result
	
	return data

func write_data(url, dict):
	if url == null: return
	
	file.open(url, File.WRITE)
	file.store_line(to_json(dict))
	file.close()