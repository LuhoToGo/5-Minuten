extends RichTextLabel

var ms = 0
var s = 0
var m = 6


func _process(delta):
	if ms < 0:
		s -= 1
		ms = 9
		
	if s < 0:
		m -= 1
		s = 59
		
	
	set_text("%02d:%02d:%02d" % [m,s,ms])



func _on_UITimer_timeout():
	ms -= 1
