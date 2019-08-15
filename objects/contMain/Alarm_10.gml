/// @desc Sync Garuntuer

if (global.turn_ready == global.turn and global.turn > 1)
	exit

var areAllSync = true
	
ini_open("communication.ini")
	for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++) {
		if (ini_read_string("General", "turnMode["+string(i)+"]", "-") != "normal") {
			areAllSync = false
			break
		}
	}

	if (ini_read_string("General", "isSynchronized", "false") != "true")
		areAllSync = false
		
	for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++) {
		if (file_exists("actions_agentPlatform_"+string(i)+".txt")) {
			areAllSync = false
			break
		}
	}
ini_close()

if (areAllSync and !global.stopGame) {
	global.turn_ready = global.turn
	
	// ?
	//recalculate_scores()
	
	if (global.player_active != global.human) {
		ini_open("communication.ini")
			if (ini_read_string("General", "turnMode["+string(global.player_active-1)+"]", "normal") == "normal")
				ini_write_string("General", "turnMode["+string(global.player_active-1)+"]", "waiting")
		ini_close()
	}
	else if (global.initialPhase) {
		global.addStructure_mode = true
		global.addStructure_object = objSettlement
	}

	var fileActions = file_text_open_write("actions_gamePlatform.txt")
		file_text_write_string(fileActions, "")
	file_text_close(fileActions)
}
else
	alarm[10] = GAME_PERIOD