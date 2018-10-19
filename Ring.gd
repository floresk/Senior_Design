extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var donut_angle = Vector3()
const ROTDELTA = 3
var t = get_transform()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	donut_angle.y += ROTDELTA
	donut_angle.x += ROTDELTA
	t.basis = Basis(Vector3(donut_angle.x ,deg2rad(donut_angle.y),0))
	set_transform(t)
