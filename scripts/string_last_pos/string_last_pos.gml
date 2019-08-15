var result = -1

for (var i = 1; i <= string_length(argument[0]); i++) {
	if (string_char_at(argument[0], i) == argument[1])
		result = i
}
		
return result