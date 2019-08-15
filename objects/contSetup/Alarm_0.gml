var fb_mode = global.fourBot_mode

if (count >= 6+fb_mode*2) {
	room_goto(roomMain)
	
	exit
}

count++

ini_open("environment.ini")
	var file = get_open_filename_ext(
	count < (4+fb_mode) ? (string(count)+". AI Agent (.class)|*.class") : (string(count-(3+fb_mode))+". Negotiation Agent (.class)|*.class"),
	"", "", "Choose "+(count < (4+fb_mode) ? "an AI agent" : "a negotiation agent"))
	
	var index = count < (4+fb_mode) ? (count-1) : (count-(3+fb_mode)-1)
	ini_write_string(count < (4+fb_mode) ? "StrategyAgents" : "NegotiationAgents", index, file == "" ? (count < (4+fb_mode) ? global.strategyAI[index+1] : global.negotiationAI[index+1]) : file)
ini_close()

alarm[0] = 1*sec