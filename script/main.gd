extends Love2d
var t
var b=false
func Load():
	var f = graphics_newFont("Softball-Gold.ttf",70)
	t = graphics_newText(f,"le texte")

func Update(delta):
	pass
func Draw():
	if keyboard_isDown(KEY_UP):
		graphics_draw(t,100,50)
