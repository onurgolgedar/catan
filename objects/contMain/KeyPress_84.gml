global.continueToggle = !global.continueToggle

if (global.stopGame)
	alarm[8] = global.continueToggle ? 2*sec : -1