/// @param playerIndex
/// @param actionParam[0]
/// @param actionParam[1]* ...
/// @param actionObject

var paramPart = string(argument[1] < 10 ? ("0"+string(argument[1])) : string(argument[1]))
var playerIndex = argument[0]
var actionType = action_trade
var actionObject = argument[argument_count-1]

for (var i = 2; i < argument_count-1; i++)
	paramPart += " "+(argument[i] < 10 ? ("0"+string(argument[i])) : string(argument[i]))
	
var fileActions = file_text_open_append("actions_gamePlatform.txt")
	file_text_write_string(
		fileActions, "P"+string(playerIndex)+" ["+actionType+" "+paramPart+"] "+actionObject+"\n"
	)
file_text_close(fileActions)

var fileActions_fromClient = file_text_open_append("actions_gamePlatform_history.txt")
	file_text_write_string(
		fileActions_fromClient, "P"+string(playerIndex)+" ["+actionType+" "+paramPart+"] "+actionObject+"\n"
	)
file_text_close(fileActions_fromClient)