#SingleInstance, Force

Gui, Add, Text, x52 y23 w121 h29, Minutes:
Gui, Add, Edit, x107 y21 w121 h20 vVTime, 5
Gui, Add, Button, x0 y50 w121 h29 gstartstop vsstoggle, Start
Gui, Add, Button, x160 y50 w121 h29 gover, E&xit
gui, show, w281 h80

TimeVar := 1 * 10000

MsgBox, 0,, % TimeVar

Loop
    {
        while toggle {
		Send, {CtrlDown}{Tab}{CtrlUp}
        Sleep TimeVar
		    if !toggle
		    break
	    }
    }
return

startstop:
	toggle := !toggle
	GuiControl,, sstoggle, % toggle ? "Stop" : "Start"
return

over:
GuiClose:
GuiEscape:
ExitApp
