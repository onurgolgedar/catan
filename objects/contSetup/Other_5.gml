ini_open("environment.ini")
for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++) {
	global.strategyAI_name[i+1] = "Player"
	global.negotiationAI_name[i+1] = ""
	
	var text = ini_read_string("StrategyAgents", i, "???")
	var text2 = ini_read_string("NegotiationAgents", i, "???")
	
	var index1 = string_last_pos(text, "\\")
	var index2 = string_last_pos(text, ".")
	
	var index1_2 = string_last_pos(text2, "\\")
	var index2_2 = string_last_pos(text2, ".")
	
	if (text != "???")
		text = string_copy(text, index1+1, index2-index1-1)
	
	if (text != "???")
		text2 = string_copy(text2, index1_2+1, index2_2-index1_2-1)
	
	global.strategyAI_name[i+1] = text
	global.negotiationAI_name[i+1] = text2
	
	global.player_name[i+1] = text+(text2 != "" ? " & " : "")+text2+" (P"+string(i+1)+")"
}
ini_close()