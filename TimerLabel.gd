extends RichTextLabel

#var ms = 0
#var s = 0
#var m = 6


func _process(_delta):
	if SavedData.ms < 0:
		SavedData.s -= 1
		SavedData.ms = 9
		
	if SavedData.s < 0:
		SavedData.m -= 1
		SavedData.s = 59
		
	
	set_text("%02d:%02d:%02d" % [SavedData.m,SavedData.s,SavedData.ms])
	
	if SavedData.m == 0 and SavedData.s == 0 and SavedData.ms == 0:
		SceneTransistor.start_transition_to("res://GameOver.tscn")



func _on_UITimer_timeout():
	SavedData.ms -= 1
