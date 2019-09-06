if(variable_global_exists("gameNo")) {
	global.gameNo = 0
	ini_open("games.ini")
		for (var i = 1; i <= 500; i++) {
			if (!ini_section_exists("Game "+string(i))) {
				global.gameNo = i
				break
			}
		}
	ini_close()
}
else
	global.gameNo = 1

global.fourBot_mode = true
global.human = global.fourBot_mode ? -999 : 1

for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++)
	global.player_name[i+1] = ""

if (file_exists(working_directory+"\\agents.ini")) {
	ini_open(working_directory+"\\agents.ini")
		var shuffle = ini_read_string("Options", "SHUFFLE_MODE", "false")
	
		var i = 0
		var j = (shuffle == "true") ? (3 - ((global.gameNo + 2) mod 4)) : 0
		repeat (4) {
			global.strategyAI[i+1] = ini_read_string("StrategyAgents", string(j), "Default")
			global.negotiationAI[i+1] = ini_read_string("NegotiationAgents", string(j), "Default")
			
			/*if (!file_exists(global.strategyAI[i+1]))
				global.strategyAI[i+1] = "Default"
			
			if (!file_exists(global.negotiationAI[i+1]))
				global.negotiationAI[i+1] = "Default"*/
				
			j = (j + 1) mod 4
			i++
		}
	ini_close()
}
else 
	show_message(working_directory+"\\agents.ini does not exists.")

for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++) {
	global.strategyAI_name[i+1] = "Player"
	global.negotiationAI_name[i+1] = ""
}

#region INIT FILES
file_delete("environment.ini")
file_delete("longest_roads.ini")
file_delete("log.txt")
file_delete("actions_gamePlatform_history.txt")

file_delete("communication.ini")
ini_open("communication.ini")
	ini_write_string("General", "isSynchronized", "true")
	
	for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++)
		ini_write_string("General", "turnMode["+string(i)+"]", "normal")
		
	ini_write_string("Game State", "isInitial", "true")
ini_close()

file_delete("actions_gamePlatform.txt")
var fileActions = file_text_open_write("actions_gamePlatform.txt")
	file_text_write_string(fileActions, "")
file_text_close(fileActions)

file_delete("log.txt")

for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++)
	file_delete("actions_agentPlatform_"+string(i)+".txt")
#endregion

if (global.gameNo == 0) {
	show_message_async("At least 500 games have been played.\nThe game is ended.")
	game_end()
}

alarm[1] = 0.5*sec
alarm[2] = 1

count = 0