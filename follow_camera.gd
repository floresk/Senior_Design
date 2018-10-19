extends Camera

func _physics_process(dt):
	var pt = get_parent().global_transform
	var pos = pt.origin + pt.basis.x * 20 + Vector3(0,1,0) * 5
	var target = pt.origin + Vector3(0,1,0)*2
	look_at_from_position(pos, target, Vector3(0,1,0))
	
	pass

func _ready():
	pass
