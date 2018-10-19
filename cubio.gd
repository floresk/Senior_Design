extends KinematicBody

#Member Variables
const MAX_SPEED = 30
const PITCH_ROLL_MAX = 15
const PITCH_ROLL_DELTA = 1
const YAW_DELTA = 3
const SCORE_INC = 1
#onready var gameover = get_node("../GameOverScene/MarginContainer/Control/VBoxContainer/HBoxContainer/Control/MarginContainer/Control/NinePatchRect/Label")
#onready var printscore = $MarginContainer/Control/VBoxContainer/HBoxContainer/Control/MarginContainer/Control/NinePatchRect/Label
var angle = Vector3()
var t = get_transform()
var collectivePitch
var score = 0
var crashed = false
var counter = 0
var donut_arrays


var x=get_translation().x
var y=get_translation().y
var z=get_translation().z




func _ready():
#	$"..PauseScene".state = get_transform() for reset in pause not working
	collectivePitch = 20
	$"explosion".hide()
	#$"cube/Arrow".hide()
	get_node("flying_sound").play(0.0)
	pass


func _physics_process(delta):
	var model = get_parent()
##	Controls
 #	Movement
	#var donut_scene = load("res://donut.tscn")
	#var donut = donut_scene.instance()
	#donut.set
	t.origin -= t.basis.x * delta * 15
	
	if(Input.is_action_pressed("move_forward")):		# Pitch forward
		t.origin -= t.basis.x * delta * MAX_SPEED
		if (angle.z < PITCH_ROLL_MAX):
			angle.z += PITCH_ROLL_DELTA
	elif(Input.is_action_pressed("move_backwards")):	# Pitch backwards
		t.origin += t.basis.x * delta * MAX_SPEED
		if (angle.z > -PITCH_ROLL_MAX):
			angle.z -= PITCH_ROLL_DELTA
	else:
		if (angle.z > 0):
			angle.z -= PITCH_ROLL_DELTA
		elif (angle.z < 0):
			angle.z += PITCH_ROLL_DELTA
			
	if(Input.is_action_pressed("move_right")):			# Yaw Right
		angle.y -= YAW_DELTA
	elif(Input.is_action_pressed("move_left")):			# Yaw Left
		angle.y += YAW_DELTA

	# Climb or Dive
	# print (clamp((model.Qs-model.Qr)/1100-5.5, -2, 2))
	# print (t.origin.y)
	
	if (clamp(((model.Qs-model.Qr)/1100)-5.5, -1, 1) > 0):
		if (t.origin.y < model.Wf * 550):
			t.origin += t.basis.y * clamp(((model.Qs-model.Qr)/1100)-5.5, -1, 1)
	else:
		t.origin += t.basis.y * clamp(((model.Qs-model.Qr)/1100)-5.5, -1, 1)

	if(Input.is_action_pressed("ui_focus_next")):		# Roll Right
		t.origin -= t.basis.z * delta * MAX_SPEED * 4
		if (angle.x > -PITCH_ROLL_MAX):
			angle.x -= PITCH_ROLL_DELTA
	elif(Input.is_action_pressed("ui_focus_prev")):		# Roll Left
		t.origin += t.basis.z * delta * MAX_SPEED * 4
		if (angle.x < PITCH_ROLL_MAX):
			angle.x += PITCH_ROLL_DELTA
	else:
		if (angle.x > 0):
			angle.x -= PITCH_ROLL_DELTA
		elif (angle.x < 0):
			angle.x += PITCH_ROLL_DELTA
		

	t.basis = Basis(Vector3(deg2rad(angle.x),deg2rad(angle.y),deg2rad(angle.z)))
	if (crashed == false):
		set_transform(t)
#	if((self.get_transform().x < -27) || (self.get_transform().x > -31)):
#		score += SCORE_INC
#	if((self.get_transform().x < -39) || (self.get_transform().x > -43)):
#		get_tree().change_scene("res://level/GameOverScene")
#	var timer = Timer.new()
#	timer.set_wait_time(3)
#	timer.set_one_shot(true)
#	self.add_child(timer)
#	timer.start()
#	yield(timer, "timeout")
#	timer.queue_free()
#	var donut_scene = load("res://donut.tscn")
#	var donut = donut_scene.instance()
#	donut.set_name("donut%s" %counter)
#	self.get_parent().add_child(donut)
#	donut.global_translate(Vector3(-50,38,0))
##	Rotor Animations
 #	Main Rotor
	var main_rotor = get_node("main_rotor")
	main_rotor.rotate(Vector3(0, 1, 0), deg2rad(200))			# Rotate 200 degrees per tick

 #	Tail Rotor
	var tail_rotor = get_node("tail_rotor")
	var t_r_xform = tail_rotor.get_transform().basis.z.normalized() # Get the basis of the Z direction
	tail_rotor.rotate(t_r_xform, deg2rad(200))						# Rotate 200 degrees per tick about the Z unit vector

	pass
"""
func _on_buildings_block_1_body_entered( body ):
	if (body == self):
		print("CRASH")
		
		get_node("crash_sound").play(0.0);
		get_node("flying_sound").stop()	;
		$"explosion".show()
		$"tail_rotor".hide()
		$"main_rotor".hide()
		$"tail".hide()
		$"cube".hide()
		
		var timer = Timer.new()
		crashed = true
		timer.set_wait_time(3)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		
		get_tree().change_scene("GameOverScene.tscn")
		
	pass


func _on_buildings_block_1_body_entered( body ):
	if (body == self):
		print("CRASH")
		
		get_node("crash_sound").play(0.0);
		get_node("flying_sound").stop()	;
		$"explosion".show()
		$"tail_rotor".hide()
		$"main_rotor".hide()
		$"tail".hide()
		$"cube".hide()
		
		var timer = Timer.new()
		crashed = true
		timer.set_wait_time(3)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		
		get_tree().change_scene("GameOverScene.tscn")
		
	pass

func _on_Donut_Area_body_entered( body ):
	get_node("get_donut_sound").play(0.0);
	if(body == self):
		score += 1
		$"/root/Data".score += 1
		$"../Donuts/Donut_Area".queue_free()
		
	pass # replace with function body


func _on_Donut_Area2_body_entered( body ):
	get_node("get_donut_sound").play(0.0);
	if(body == self):
		score += 1
		$"/root/Data".score += 1
		$"../Donuts/Donut_Area2".queue_free()
	pass # replace with function body


func _on_Donut_Area3_body_entered( body ):
	get_node("get_donut_sound").play(0.0);
	if(body == self):
		score += 1
		$"/root/Data".score += 1
		$"../Donuts/Donut_Area3".queue_free()
	pass # replace with function body


func _on_Donut_Area4_body_entered( body ):
	get_node("get_donut_sound").play(0.0);
	if(body == self):
		score += 1
		$"/root/Data".score += 1
		$"../Donuts/Donut_Area4".queue_free()
	pass # replace with function body


func _on_Donut_Area5_body_entered( body ):
	get_node("get_donut_sound").play(0.0);
	if(body == self):
		score += 1
		$"/root/Data".score += 1
		$"../Donuts/Donut_Area5".queue_free()
	pass # replace with function body
"""
