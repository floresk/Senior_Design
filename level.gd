extends Spatial

onready var number_label = $FPS/GUI/Control2/Bars2/Control2/Power/Control/Count/Control/Background/Number
onready var number_label2 = $FPS/GUI/Control/Bars/Control/LifeBar/Control/Count/Control/Background/Number
onready var bar = $FPS/GUI/Control2/Bars2/Control2/Power/Control/TextureProgress
onready var bar2 = $FPS/GUI/Control/Bars/Control/LifeBar/Control/TextureProgress
onready var coins= $FPS/GUI/Control3/Points/Coins/Control/Count/Control/Background/Number
#onready var coins_label= $FPS/GUI/Control3/Points/Coins/Control/Count/Control/Background/Number
onready var barT = $FPS/GUI/ControlT/BarsT/ControlT/Torque/Control/TextureProgress
onready var baralt = $FPS/GUI/ControlAlt/BarsAlt/ControlAlt/Alt/ControlAlt/TextureProgress
onready var baralt_label = $FPS/GUI/ControlAlt/BarsAlt/ControlAlt/Alt/ControlAlt/Count/ControlAlt/Background/Label
onready var barng = $FPS/GUI/ControlAlt/BarsAlt/ControlAlt/Alt/ControlAlt/TextureProgress2
onready var barng_label = $FPS/GUI/ControlAlt/BarsAlt/ControlAlt/Alt/ControlAlt/Count/ControlAlt/Background/Label2
onready var barT_label = $FPS/GUI/ControlT/BarsT/ControlT/Torque/Control/Count/Control/Background/Label

const SPEED = 10
const CYCLIC_MAX = 10
const COLLECTIVE_MAX = 100
const COLLECTIVE_MIN = -300
const COLL_DEL = 2

var u = [100, 0.080]
var Wf = 0
var cyclicLoad = 0
var collectiveLoad = 0
var collectivePitch = 0
var Qr = 0
var Qs = 0
var Np = 0

var x1 = [[0],[0],[0],[0],[0],[0],[0],[0]]
var x2 = [[0],[0],[0],[0],[0],[0],[0],[0]]
var x3 = [[0],[0],[0],[0],[0],[0],[0],[0]]
var x4 = [[0],[0],[0],[0],[0],[0],[0],[0]]
var x5 = [[0],[0],[0],[0],[0],[0],[0],[0]]

var y1 = [[87.0],[6800],[0],[0]]
var y2 = [[0],[0],[0],[0]]
var y3 = [[0],[0],[0],[0]]
var y4 = [[0],[0],[0],[0]]
var y5 = [[0],[0],[0],[0]]

var y0

var D1 = [[0,0,0,0,-.5693,.0007,.0029,-.0007],[0,0,0,0,-.1112,-.0251,0.0340,-.1119],[0,0,0,0,.0060,-.0110,-.0156,-.0769],[0,0,0,0,-.2870,-.0045,.0265,-.1018],[1,0,0,0,1.5083,.0052,.0244,.0152],[0,1,0,0,.0540,1.0484,.1716,.0699],[0,0,1,0,.0513,-.0035,.8414,-.1075],[0,0,0,1,.2935,.0377,.1450,1.0227]]
var E1 = [[0,-.3489],[.0039,-1.7818],[-.0001,-1.9504],[-.0001,-1.1076],[0,.3906],[-.0038,1.6791],[.0001,2.2966],[.0002,.9788]]
var F1 = [[.0290],[-.2349],[.1833],[.1074],[-.0355],[.2350],[-.2097],[-.1086]]
var G1 = [[0,0,0,0,5.0,0,0,0],[0,0,0,0,0,3515.0,0,0],[0,0,0,0,0,0,195.4,0],[0,0,0,0,0,0,0,24.1]]
var Z1 = [[87.5],[9369.9],[1472.3],[132.0]]

var D2 = [[0,0,0,0,-.0854,.0042,.0303,-.2789],[0,0,0,0,-.1431,-.0124,.0263,-.2383],[0,0,0,0,.1316,-.0214,-.003,.0115],[0,0,0,0,-.0490,.0054,.0155,-.2032],[1,0,0,0,.9005,.0387,.1179,.3565],[0,1,0,0,.2190,.9875,.0232,.0826],[0,0,1,0,-.2122,.0224,.9004,.1200],[0,0,0,1,.0651,.0027,.0488,1.0918]]
var E2 = [[.0003,-1.2022],[.0054,-1.8996],[-.0001,-3.4306],[-.0001,-1.0120],[0,1.1722],[-.0055,2.0429],[.0001,3.7381],[.0002,1.0806]]
var F2 = [[.1121],[-.3146],[.4131],[.1308],[-.1333],[.3105],[-.4496],[-.1443]]
var G2 = [[0,0,0,0,20.0,0,0,0],[0,0,0,0,0,35150.0,0,0],[0,0,0,0,0,0,977.0,0],[0,0,0,0,0,0,0,241.0]]
var Z2  =[[91.00],[15309.0],[1578.0],[162.0]]

var D3 = [[0,0,0,0,-.3647,-.0018,-.0299,-.048],[0,0,0,0,-.2227,-.0238,-.0234,-.2175],[0,0,0,0,.0683,-.004,.0111,-.0043],[0,0,0,0,-.0907,-.003,-.0071,-.2529],[1,0,0,0,1.4046,.033,.1345,-.1597],[0,1,0,0,.3485,.9633,.0278,.0699],[0,0,1,0,-.1249,-.0291,.8871,.1523],[0,0,0,1,.1720,-.0049,.0422,1.0942]]
var E3 = [[.0001,-1.3495],[.0067,-1.9331],[-.0004,-2.6354],[-.0002,-1.0774],[.0002,1.4103],[-.0071,2.2315],[.0002,2.8748],[.0002,1.2196]]
var F3 = [[.1882],[-.3854],[.4276],[.1818],[-.2208],[.3835],[-.4379],[-.1984]]
var G3 = [[0,0,0,0,20.0,0,0,0],[0,0,0,0,0,35150.0,0,0],[0,0,0,0,0,0,977.0,0],[0,0,0,0,0,0,0,241.0]]
var Z3 = [[95.0],[21443.0],[1675.0],[189.0]]

var D4 = [[0,0,0,0,-.1189,.0117,-.0555,-.2425],[0,0,0,0,-.1117,.0001,-.0694,-.2907],[0,0,0,0,-.1844,-.0053,-.0231,.1612],[0,0,0,0,.0141,.0062,-.0314,-.2777],[1,0,0,0,1.2199,.0296,.1830,-.1058],[0,1,0,0,.4792,.9547,.1041,-.1177],[0,0,1,0,.1081,-.0554,.8530,.1633],[0,0,0,1,.2352,.0041,.1156,.8711]]
var E4 = [[.0002,-1.3652],[.0082,-2.1470],[-.0004,-2.4216],[-.0003,-1.1647],[.0002,1.3654],[-.0086,2.2683],[-.0001,2.6815],[.0004,1.1848]]
var F4 = [[.2187],[-.4475],[.4639],[.2341],[-.2562],[.4652],[-.4549],[-.2478]]
var G4 = [[0,0,0,0,20.0,0,0,0],[0,0,0,0,0,35150.0,0,0],[0,0,0,0,0,0,977.0,0],[0,0,0,0,0,0,0,241.0]]
var Z4 = [[97.0],[27303.0],[1778.0],[212.0]]

var D5 = [[0,0,0,0,.1907,.007,.0524,-.5436],[0,0,0,0,.2123,-.0049,.0805,-.5187],[0,0,0,0,-.0201,.0044,.0145,-.1358],[0,0,0,0,.201,.0008,.0765,-.4728],[1,0,0,0,.8479,.0651,.4640,-.0258],[0,1,0,0,-.1461,.9894,.0142,.3239],[0,0,1,0,-.012,-.0284,.8055,.3132],[0,0,0,1,-.0855,.0273,.1515,1.0695]]
var E5 = [[.0002,-2.2727],[.0099,-1.8996],[0,-2.7338],[-.0007,-1.7053],[.0006,2.4826],[-.0101,2.1337],[-.0002,2.8933],[.001,1.9276]]
var F5 = [[.4455],[-.6058],[.5555],[.4108],[-.5654],[.5726],[-.5624],[-.4874]]
var G5 = [[0,0,0,0,10.0,0,0,0],[0,0,0,0,0,17575.0,0,0],[0,0,0,0,0,0,977.0,0],[0,0,0,0,0,0,0,241.0]]
var Z5 = [[98.0],[32619.0],[1896.0],[232.0]]
	
func getY(D,E,F,G,Z,u,x):
	# D = 8:8
	# E = 8:2
	# F = 8:1
	# G = 4:8
	# Z = 4:1
	# u = 1:2 
	# x = 8:1
	
	# x = D*x + E*u' + F
	# x = A + B + F
	
	# y = G*x + Z
	# y = C + Z

	var sum
	var A = [[0],[0],[0],[0],[0],[0],[0],[0]]
	var B = [[0],[0],[0],[0],[0],[0],[0],[0]]
	
	var y = [[0],[0],[0],[0]]
	var C = [[0],[0],[0],[0]]
	
	u = [[u[0]],[u[1]]]
	
	for i in range(8):
		sum = 0
		for k in range (8):
			sum += D[i][k] * x[k][0]
		A[i][0] += sum
			
	for i in range(8):
		sum = 0
		for k in range (2):
			sum += E[i][k] * u[k][0]
		B[i][0] += sum
	
	for i in range(8):
		x[i][0] = A[i][0] + B[i][0] + F[i][0]
			
	for i in range(4):
		sum = 0
		for k in range (8):
			sum += G[i][k] * x[k][0]
		C[i][0] += sum
	
	for i in range (4):
		y[i][0] = C[i][0] + Z[i][0]
	
	return y


var donut_counter = 0 
var building_counter = 0
var donut_scene = load("res://donut.tscn")
var building_scene = load("res://building.tscn")
var random_donut_y
func generate_donuts():
	# generate donuts
	random_donut_y =  90+(randi()%8)
	if (donut_counter < 1):
		#var timer = Timer.new()
		#timer.set_wait_time(3)
		var donut = donut_scene.instance()
		donut.set_name("donut%s"%donut_counter)
		#previous donut y:  $cubio.t.origin[1]+randi()%3+7
		donut.set_translation( Vector3($cubio.t.origin[0]-(randi()%3+1)*15-30, random_donut_y, $cubio.t.origin[2]+2*(randi()%3)+5) )  #generate donut randomly
		self.get_node("Donuts").add_child(donut)
		donut_counter+=1

	
		
func donut_collision_detector():
	if donut_counter>0:
		for child in get_node("Donuts").get_children():
			var donut_location = child.get_translation()
			var heli_location = get_node("cubio").get_translation()
			"""
			var x_diff = donut_location.x - $cubio.t.origin[0]
			var y_diff = donut_location.y - $cubio.t.origin[1]
			var z_diff = donut_location.z - $cubio.t.origin[2]
			"""
			#print(child.get_name())
		
			var x_diff = donut_location.x - heli_location.x
			var y_diff = donut_location.y - heli_location.y
			var z_diff = donut_location.z - heli_location.z
			var distance = sqrt(pow(x_diff,2)+pow(y_diff,2)+pow(z_diff,2))
			var collided = (abs(x_diff)<2 and abs(y_diff)<2 and abs(z_diff)<2 )
	#		if (distance < 0.6):
			if (collided):
				print(str(distance))
				print(child.get_name())
				$cubio.score += 1
				$"/root/Data".score += 1
				get_node("cubio/get_donut_sound").play(0.0)
				donut_counter-=1			
				child.hide()
				child.free()
			
			
			elif (heli_location.x < donut_location.x-4):
				child.hide()
				child.free()
				donut_counter-=1	
	
	
func generate_buildings():	
	var timer = Timer.new()

	var previous_build_x = (randi()%3+1)*15-40 
	if (building_counter < 3):
		var building = building_scene.instance()
		building.set_name("building%s"%building_counter)
		building.set_translation( Vector3($cubio.t.origin[0]-previous_build_x-100*building_counter, 0, $cubio.t.origin[2]+2*(randi()%3)+5) )  #generate donut randomly
		self.get_node("Buildings").add_child(building)
		building_counter+=1
		
		
func building_collision_detector():
	if building_counter>0:
		for child in get_node("Buildings").get_children():
			var build_location = child.get_translation()
			var heli_location = get_node("cubio").get_translation()
			var x_diff = abs(build_location.x - heli_location.x)
			var y_diff = build_location.y - heli_location.y
			var z_diff = abs(build_location.z - heli_location.z)
			
		
			var distance = sqrt(pow(x_diff,2)+pow(y_diff,2)+pow(z_diff,2))
	#		if (distance < 10):
		
			# collision_detected 
			if (heli_location.y< 60 and (x_diff < 1 or z_diff<1) ):
				get_node("cubio/crash_sound").play(0.0);
				get_node("cubio/flying_sound").stop();
				$"cubio/explosion".show()
				$"cubio/tail_rotor".hide()
				$"cubio/main_rotor".hide()

				child.hide()
				child.free()
				
				var timer = Timer.new()
				$cubio.crashed = true
				timer.set_wait_time(3)
				timer.set_one_shot(true)
				self.add_child(timer)
				timer.start()
				yield(timer, "timeout")
				timer.queue_free()
				
				get_tree().change_scene("GameOverScene.tscn")
				break
			
			# passed the building, delete node !
			elif (abs(heli_location.x-build_location.x) < 13):
				building_counter-=1
				child.hide()
				child.free()
				
			
			
			
			
func _ready():
	u = [100, 0.08]
	y0=y1
	Wf = 0.08
	pass

func _process(delta):
	# u[0] = Power Turbine Speed
	# u[1] = Fuel Flow
	#var timer = Timer.new()
	generate_donuts()
	#timer.set_wait_time(10)
	donut_collision_detector()
	
	generate_buildings()
	building_collision_detector()
		
	#print("counter:  "+str(counter) )
	
	cyclicLoad = 0
	if Input.is_action_pressed("ui_up"):
		Wf += 0.001
	if Input.is_action_pressed("ui_down"):
		Wf -= 0.001
	if Input.is_action_pressed("ui_left"):
		Np -= 1
	if Input.is_action_pressed("ui_right"):
		Np += 1
	
	if Input.is_action_pressed("move_right"):		# Yaw Right
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 0.005
	if Input.is_action_pressed("move_left"):		# Yaw Left
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 0.005
	if Input.is_action_pressed("move_up"):			# Pitch Forward
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 1
	if Input.is_action_pressed("move_down"):		# Pitch Backwards
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 1
	if Input.is_action_pressed("ui_page_up"):		# Climb
		if (collectiveLoad > COLLECTIVE_MIN):
			collectiveLoad -= 1*COLL_DEL
	if Input.is_action_pressed("ui_page_down"):		# Dive
		if (collectiveLoad < COLLECTIVE_MAX):
			collectiveLoad += 1*COLL_DEL
	if Input.is_action_pressed("ui_focus_next"):	# Roll Right
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 0.06
	if Input.is_action_pressed("ui_focus_prev"):	# Roll Left
		if (cyclicLoad < CYCLIC_MAX):
			cyclicLoad += 0.06
	
	Qs = clamp(y0[1][0], 0 , 200000000)
	Qr = cyclicLoad*10000+collectiveLoad*100
	
	u = [((Qs-Qr)/420)+63+Np, Wf]
	#print (u)
	
	y1 = getY(D1, E1, F1, G1, Z1, u, x1)
	y2 = getY(D2, E2, F2, G2, Z2, u, x2)
	y3 = getY(D3, E3, F3, G3, Z3, u, x3)
	y4 = getY(D4, E4, F4, G4, Z4, u, x4)
	y5 = getY(D5, E5, F5, G5, Z5, u, x5)
	
	
	if (y0[0][0] < 85.0):
		get_tree().change_scene("res://GameOverScene.tscn")
	elif (y0[0][0] < 87.0):
		y0 = y1
		
	elif (y0[0][0] < 91.0):
		y0 = y2
		
	elif (y0[0][0] < 94.0):
		y0 = y3
		
	elif (y0[0][0] < 96.0):
		y0 = y4
		
	elif (y0[0][0] < 99.9):
		y0 = y5
	else:
		get_tree().change_scene("res://GameOverScene.tscn")
	
	$u.text = "" #"u: [" + str(u[0]) + "," + str(u[1]) + "]"
	$Ng.text = ""#"Ng: " + str(y0[0][0])
	$Qs.text = ""#"Qs: " + str(y0[1][0])
	$T.text = ""#"T: " + str(y0[2][0])
	$P.text = ""#"P: " + str(y0[3][0])
	
	#var np = tanh(u[0])
	var np=clamp(u[0]+23, 98,102)
	#var np=tanh(u[0]/max(u[0]))
	bar.max_value = 102
	bar.min_value = 98
	bar2.max_value = .15
	barT.max_value = 20000
	barT.min_value = 7000
	baralt.max_value = 200
	barng.max_value = 88
	barng.min_value = 87
	barng_label.text = "Ng:" + str(y0[0][0])
	barng.value = y0[0][0]
	#bar.min_value=98
	baralt_label.text = "Altitude: " + str($cubio.t.origin[1])
	number_label.text = "%" + str(np)#u[0])#str(1/(1+pow(2.718,-u[0])))#u[0] + 23)
	bar.value = np# (1/(1+pow(2.718,-u[0]))) #u[0] + 23
	number_label2.text = str(u[1]) + "lb/sec"
	bar2.value = u[1]
	barT.value = y0[1][0]
	baralt.value = $cubio.t.origin[1]
	barT_label.text = "Torque: " + str(y0[1][0])
	coins.text = str($cubio.score)
	pass
	
	
