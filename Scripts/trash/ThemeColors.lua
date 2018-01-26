-- theme colors (not to be confused with 03 Colors)
local TapNoteScoreColors = {
	TapNoteScore_W1 = color("#bfa300"), -- was #4a3f00, #806c00
	TapNoteScore_W2 = color("#b9bf00"), -- was #474a00, #7b8000
	TapNoteScore_W3 = color("#10bf00"), -- was #064a00, #0b8000
	TapNoteScore_W4 = color("#0063bf"), -- was #00264a, #004280
	TapNoteScore_W5 = color("#bf0086"), -- was #4a0034, #800059
	TapNoteScore_Miss = color("#bf0000"), -- was #4b0000, #800000
};
function TapNoteScoreColor( tns ) return TapNoteScoreColors[tns]; end;

