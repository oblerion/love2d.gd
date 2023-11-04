# love2d.gd ver b0.1
class_name Love2d extends Node2D
var _mouse =[0,0,false,false,false];
var _touch=[];
var _key_press=[];
var _key_down=[];
var _delta;
var _curant_color=Color.white;
var _curant_font=null;
var _graphics_list=[];
# define in derivate ----------------
func Load():
	pass
func Update(delta):
	pass
func Draw():
	pass
# public function  --------------------
func mouse_isDown(id:int) -> bool:
	if id<1 and id>3: 
		return false;
	return _mouse[id+1]
func mouse_getX() -> int:
	return _mouse[0]
func mouse_getY() -> int:
	return _mouse[1]
func keyboard_isPress(key:int) -> bool:
	if _key_press.find(key)!=-1:
		return true;
	return false;
func keyboard_isDown(key:int) -> bool:
	if _key_down.find(key)!=-1 or keyboard_isPress(key)==true:
		return true;
	return false;
func timer_getDelta() ->float:
	return _delta;

func window_getWidth() ->float:
	return get_viewport().size.x
func window_getHeight() ->float:
	return get_viewport().size.y

func graphics_newImage(filepath:String) -> Texture:
	var spr;
	var rload = load("res://"+filepath)
	if rload != null:
		spr=rload;
		print("texture ",filepath," load")
	else:
		spr = Texture.new();
		print("texture ",filepath," can't be found")
	return spr;
func graphics_setColor(color:Color) -> void:
	_curant_color=color
func graphics_getColor() -> Color:
	return _curant_color
func graphics_draw(e:Texture,x:int,y:int) -> void:
	for le in _graphics_list:
		if le is Texture and le.texture==e:
			return;
	var lspr = Sprite.new();
	lspr.position=Vector2(x,y);
	lspr.set_texture(e);
	add_child(lspr);
	_graphics_list.push_back(lspr);

func graphics_print(s:String,x:int,y:int,r:float) ->void:
	var lab = null
	for le in _graphics_list:
		if le is Label and le.text==s:
			lab = le
			break;
	if lab==null: 
		lab = Label.new();
		add_child(lab);
		_graphics_list.push_back(lab);
	lab.text=s;
	lab.set_position(Vector2(x,y));
	lab.set_rotation(r)
	lab.set("custom_colors/font_color", _curant_color)
func system_openURL(url:String):
	if OS.shell_open(url):
		return true
	return false
# ------------------------ system 
func _ready():
	return Load();
func _process(delta):
	_delta=delta;
	Update(delta);
	Draw();
func _input(event):
	if event is InputEventMouseButton:
		for i in range(1,3):
			if event.button_index==i and event.pressed==true:
				_mouse[i]=true;
			else: 
				_mouse[i]=false;
	elif event is InputEventMouseMotion:
		_mouse[0]=event.position.x;
		_mouse[1]=event.position.y;
	_touch=[];
	if event is InputEventScreenTouch:
		if event.pressed==true:
			_touch[event.index]=event.position;
	_key_down=[];
	_key_press=[];
	if event is InputEventKey:
		if event.pressed==true:
			if event.echo==true:
				_key_down.push_back(event.scancode);
			else:
				_key_press.push_back(event.scancode);
	
