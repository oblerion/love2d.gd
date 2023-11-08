# love2d.gd ver b0.2
class_name Love2d extends Node2D
var _mouse =[0,0,false,false,false];
var _touch=[];
var _key_press=[];
var _key_down=[];
var _delta;
var _curant_color=Color.white;
var _curant_font=null;
var _graphics_todraw=[]
var _graphics_draw=[]
# define in derivate ----------------
func Load():
	pass
func Update(delta):
	pass
func Draw():
	pass
# ------------------------ internal system
func _graphics_managerId() -> void:
	var labelid=0
	var spriteid=0
	for e in _graphics_draw:
		if e is Label:
			e.name = "label"+var2str(labelid)
			labelid+=1
		elif e is Sprite:
			e.name = "sprite"+var2str(spriteid)
			spriteid+=1
func _graphics_find(list:Array,e:CanvasItem) -> int:
	var i=0;
	for le in list:
		if le is Label and e is Label:
			if le.text == e.text and le.get_position() == e.get_position():
				return i
		elif le is Sprite and e is Sprite:
			if le.texture == e.texture and le.position == e.position:
				return i
		i+=1
	return -1
func _graphics_new(e:CanvasItem) -> void:
	if _graphics_find(_graphics_todraw,e)==-1:
		_graphics_todraw.push_back(e)
func _graphics_clear() -> void:
	for d in _graphics_draw:
		if _graphics_find(_graphics_todraw,d)==-1:
			_graphics_draw.erase(d)
			remove_child(d)
	_graphics_todraw.clear()
func _graphics_push() -> void:
	for td in _graphics_todraw:
		if _graphics_find(_graphics_draw,td)==-1:
			add_child(td)
			_graphics_draw.push_back(td)
			
func _graphics_newLabel(text:String,x:int,y:int,r:float) -> void:
	var lab = Label.new();
	lab.text=text;
	lab.set_position(Vector2(x,y));
	lab.set_rotation(r)
	if _curant_font!=null:
		lab.set("custom_fonts/font",_curant_font)
	lab.set("custom_colors/font_color", _curant_color)
	_graphics_new(lab)
func _graphics_newLabelL(label:Label) -> void:
	_graphics_new(label)
func _graphics_newSprite(ptexture:Texture,x:int,y:int) -> void:
	var lspr = Sprite.new();
	lspr.position=Vector2(x,y);
	lspr.set_texture(ptexture);
	_graphics_new(lspr)

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
func graphics_newText(font:Font,text:String) -> Label:
	var lab = Label.new();
	lab.text=text;
	lab.set_position(Vector2.ZERO);
	lab.set_rotation(0)
	if font!=null:
		lab.set("custom_fonts/font",font)
	lab.set("custom_colors/font_color", _curant_color)
	return lab
func graphics_newFont(path:String,size:int) -> DynamicFont:
		var df = DynamicFont.new()
		df.font_data = load("res://"+path)
		df.size = size
		return df
func graphics_setFont(font:Font) -> void:
	_curant_font=font
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
func graphics_setAlpha(pa:int) -> void:
	_curant_color.a=pa
func graphics_draw(e:Object,x:int,y:int) -> void:
	if e is Texture:
		_graphics_newSprite(e,x,y)
	elif e is Label:
		e.set_position(Vector2(x,y))
		_graphics_newLabelL(e)
func graphics_print(s:String,x:int,y:int,r:float) ->void:
	_graphics_newLabel(s,x,y,r)
func system_openURL(url:String):
	if OS.shell_open(url):
		return true
	return false
func math_random(pmin:int,pmax:int=0) -> int:
	if pmax==0:
		return randi()%pmin
	return randi()%pmax+pmin
# ------------------------ system 
func _ready():
	return Load();
func _process(delta):
	_graphics_clear()
	_graphics_managerId()
	_delta=delta;
	Update(delta);
	Draw();
	_graphics_push()
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
	
