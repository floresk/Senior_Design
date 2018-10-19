extends Spatial

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$GameOver/Score.text = "Your Score: " + str($"/root/Data".score)
	pass

func _process(delta):
	pass


func _on_Quit_pressed():
	get_tree().quit()
	pass # replace with function body
