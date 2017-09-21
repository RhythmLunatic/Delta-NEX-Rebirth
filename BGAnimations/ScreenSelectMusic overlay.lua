local isSelectingDifficulty = false;
local musicWheel;

local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or isSelectingDifficulty then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	--Keytester
	--SCREENMAN:SystemMessage(button.." "..tostring(isSelectingDifficulty));
	if button == "UpLeft" or button == "UpRight" then
		SCREENMAN:GetTopScreen():GetChild('MusicWheel'):SetOpenSection("");
	end;
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
	
        --Custom input code that isn't confusing at all /s
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		--SCREENMAN:set_input_redirected(PLAYER_1,false);
	end;
	SongChosenMessageCommand=function(self)
		isSelectingDifficulty = true;
	end;
	
	--Needs to sleep because without it, isSelectingDifficulty will be false while they close the difficulty select instead of after.
	TwoPartConfirmCanceledMessageCommand=function(self)
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	SongUnchosenMessageCommand=function(self)
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	DifficultySelectExitedCommand=function(self)
		isSelectingDifficulty = false;
	end;
}


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