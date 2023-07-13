#SingleInstance, Force

Gui, Add, Button, x0 y21 w121 h29 gstartstop vsstoggle, Start
Gui, Add, Button, x160 y21 w121 h29 gover, E&xit

gui, show, w281 h50

Loop
    {
        while toggle {
			MouseMove, 0, 100, 0
			MouseMove, 0, 0, 0
			Sleep, 300000
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