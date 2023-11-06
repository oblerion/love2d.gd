extends Love2d
var t
var b=false
func Load():
	t = graphics_newImage("icon.png")
func Update(delta):
	pass
func Draw():
	if keyboard_isDown(KEY_UP):
		graphics_draw(t,50,50)
	graphics_print("hello",45,45,0)
