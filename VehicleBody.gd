extends VehicleBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector3()
var rotation_dir = 0



func get_input():
	if Input.is_action_pressed("ui_up"):
		#thrust = Vector3(engine_thrust,0, 0)
		apply_impulse(Vector3(), thrust * 5)
	else:
		thrust = Vector3()
		apply_impulse(Vector3(), -thrust * 5)
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	
	

func _process(delta):
	get_input()
	
	
#func _physics_process(delta):
	#apply_impulse(_force(thrust.rotated(rotation,3))
	#set_applied_torque(rotation_dir * spin_thrust)
	#apply_impulse()
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

extends KinematicBody

# Member variables
var g = -9.8
var vel = Vector3()
const MAX_SPEED = 5
const JUMP_SPEED = 7
const ACCEL= 2
const DEACCEL= 4
const MAX_SLOPE_ANGLE = 30


func _physics_process(delta):
	var dir = Vector3() # Where does the player intend to walk to
	var cam_xform = get_node("target/camera").get_global_transform()
	
	if (Input.is_action_pressed("move_forward")):
		dir += -cam_xform.basis[2]
	if (Input.is_action_pressed("move_backwards")):
		dir += cam_xform.basis[2]
	if (Input.is_action_pressed("move_left")):
		dir += -cam_xform.basis[0]
	if (Input.is_action_pressed("move_right")):
		dir += cam_xform.basis[0]
	
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta*g
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir*MAX_SPEED
	var accel
	if (dir.dot(hvel) > 0):
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel*delta)
	
	vel.x = hvel.x
	vel.z = hvel.z
	
	vel = move_and_slide(vel,Vector3(0,1,0))
	
	if (is_on_floor() and Input.is_action_pressed("jump")):
		vel.y = JUMP_SPEED
	
	var crid = get_node("../elevator1").get_rid()

