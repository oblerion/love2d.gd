extends Love2d
var t
var b=false
func Load():
	t = graphics_newImage("icon.png")
func Update(delta):
	pass
func Draw():
	if keyboard_isDown(KEY_UP)==true:
		system_openURL("/home/desnot")
