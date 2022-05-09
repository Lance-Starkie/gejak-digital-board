extends CanvasLayer

func full_select(locations):
	deselect()
	$SelectorMain.go_to(locations[0][0])
	if locations[1][1]:
		$Selector1.go_to(locations[1][0])
	if locations[2][1]:
		$Selector2.go_to(locations[2][0])
	
func single_select(location,type = 0):
	deselect()
	if type == 3:
		$SelectorMain.get_node("Sprite").flip_v = true
		type = 2
	$SelectorMain.get_node("Sprite").frame = type
	$SelectorMain.go_to(location)
	
func deselect():
	$SelectorMain.get_node("Sprite").frame = 0
	$SelectorMain.get_node("Sprite").flip_v = false
	$SelectorMain.hide()
	$Selector1.hide()
	$Selector2.hide()
