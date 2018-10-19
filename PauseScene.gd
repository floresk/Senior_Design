extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var state = Transform()


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func _on_UnpauseButton_pressed():
	$Pause_Popup.hide()
	get_tree().paused = false
	pass # replace with function body


func _on_Restart_pressed():
	$Pause_Popup.hide()
	get_tree().quit() 
#	$"../cubio".set_transform(state) reset not working
#	get_tree().reload_current_scene()
	pass # replace with function body
	
func _process(delta):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().paused = true
		$Pause_Popup.show()
		$Pause_Popup/UnpauseButton.show()
		$Pause_Popup/Restart.show() 
		$Pause_Popup/Label.show()