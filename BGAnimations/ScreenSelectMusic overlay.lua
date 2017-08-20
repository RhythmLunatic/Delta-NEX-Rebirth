local t = Def.ActorFrame{}


t[#t+1] = LoadActor(THEME:GetPathS("","EX_Move"))..{
	OptionsListOpenedMessageCommand=cmd(play);
	OptionsListClosedMessageCommand=cmd(play);	
	OptionsListRightMessageCommand=cmd(play);
	OptionsListLeftMessageCommand=cmd(play);	
	OptionsListQuickChangeMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Confirm"))..{
	OptionsListClosedMessageCommand=cmd(play);	
	OptionsListStartMessageCommand=cmd(play);
	OptionsListResetMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","EX_Select"))..{
	OptionsListPopMessageCommand=cmd(play);
	OptionsListPushMessageCommand=cmd(play);	
}
t[#t+1] = LoadActor(THEME:GetPathS("","Common Cancel"))..{
	SongUnchosenMessageCommand=cmd(play);
}


return t