local isSelectingDifficulty = false;
local ScreenSelectMusic;

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
	--I'm sorry, but this was the easiest way to get it to move the musicwheel when a folder was closed/opened...
	--[[if button == "Center" then
		MESSAGEMAN:Broadcast("CurrentSongChanged");
	end]]

	--Check if they're in ScreenSelectMusic. If they're in ScreenSelectMusicBasic or any other screen, then don't allow them to close the folder.
	if ScreenSelectMusic:GetName() == "ScreenSelectMusic" then
		if SCREENMAN:get_input_redirected(pn) then --If the player is in the command window
			if button == "DownRight" then
				MESSAGEMAN:Broadcast("CWChangeIndexMessageCommand", {Player=pn,Direction=1})
			elseif button == "DownLeft" then
				MESSAGEMAN:Broadcast("CWChangeIndexMessageCommand", {Player=pn,Direccion=-1})
			elseif button == "UpRight" or button == "UpLeft" then
				MESSAGEMAN:Broadcast("CommandWindowClosed", {Player = pn})
				SCREENMAN:set_input_redirected(pn, false);
			end;
		else
			if button == "UpRight" or button == "UpLeft" then
				if ScreenSelectMusic:CanOpenOptionsList(pn) then --If options list isn't currently open
					--ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
					secondsLeft = ScreenSelectMusic:GetChild("Timer"):GetSeconds()
					--Set a global variable so ScreenSelectGroup will jump to the group that was selected before.
					initialGroup = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection()
					SCREENMAN:SetNewScreen("ScreenSelectGroup");
					
					--Yes, this is actually how the StepMania source does it. It's pretty buggy.
					--local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
					--local sectionName = MusicWheel:GetSelectedSection("");
					--Unfortunately not lua accessible...
					--MusicWheel:SelectSection(sectionName);
					--SCREENMAN:SystemMessage(MusicWheel:GetCurrentIndex());
					--It's broken???
					--MusicWheel:Move(5);
					--MusicWheel:SetOpenSection("");
					
					--And this is the new function that's far less buggy.
					--ScreenSelectMusic:CloseCurrentSection();
					
					--Debugging stuff
					
				end
			end;
		end;
	end;
	
	if button == "MenuUp" then
		--SCREENMAN:SystemMessage(button.." "..tostring(isSelectingDifficulty));
		--local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
		--local currentWheelItem = MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex());
		--[[local jacket = GetSongGroupJacketPath(groupName)
		if jacket then
			SCREENMAN:SystemMessage(jacket);
		else
			SCREENMAN:SystemMessage("no jacket");
		end;]]
		SCREENMAN:SystemMessage(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
		--	SCREENMAN:SystemMessage(currentWheelItem:GetChild("CourseNormalPart"):GetChild("SongBanner"):GetChildren())
	elseif button == "MenuDown" then
		--[[local groupName = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection();
		local banner = SONGMAN:GetSongGroupBannerPath(groupName);
		SCREENMAN:SystemMessage(banner);]]
		--[[local MusicWheel = ScreenSelectMusic:GetChild('MusicWheel');
		SCREENMAN:SystemMessage(MusicWheel:GetWheelItem(MusicWheel:GetCurrentIndex()):GetType());]]
		SCREENMAN:SystemMessage(ScreenSelectMusic:GetChild("Timer"):GetSeconds());
	end
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
		ScreenSelectMusic = SCREENMAN:GetTopScreen();
		--Custom input code that isn't confusing at all /s
		ScreenSelectMusic:AddInputCallback(inputs);
		--SCREENMAN:set_input_redirected(PLAYER_1, true)
		
		--Set timer if we came from ScreenSelectGroup
		if secondsLeft ~= nil then
			ScreenSelectMusic:GetChild("Timer"):SetSeconds(secondsLeft)
			--Remove it so we start with 99 seconds if the player is returning from song results, or they reloaded the screen.
			secondsLeft = nil
		end;
		
		--CurrentGroup comes from the group select overlay (It's a global variable hack!)
		if currentGroup ~= nil then
			SCREENMAN:SystemMessage(currentGroup);
			ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(currentGroup);
			ScreenSelectMusic:GetChild('MusicWheel'):Move(1);
			ScreenSelectMusic:GetChild('MusicWheel'):Move(0);
			--Set it back to nil so it doesn't switch songs every time you exit and enter the same folder (or returning from a song)
			currentGroup = nil;
			--This doesn't actually work. I think the MusicWheel is bugged.
			--[[local songs = SONGMAN:GetSongsInGroup(currentGroup);
			local out = ScreenSelectMusic:GetChild('MusicWheel'):SelectSong(songs[1])
			SCREENMAN:SystemMessage(tostring(out).." "..songs[1]:GetTranslitMainTitle());]]
		end;
	end;
	
	CodeMessageCommand=function(self, params)
		if params.Name == "GoFullMode" then
			ScreenSelectMusic:lockinput(1);
			--SCREENMAN:SystemMessage("Full Mode triggered!");
			GAMESTATE:ApplyGameCommand("sort,group");
			--ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_SOUND"));
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_VOICE"));
			MESSAGEMAN:Broadcast("GoFullMode");
			initialGroup = nil; --It can be left over from a previous session
			inBasicMode = false;
			secondsLeft = ScreenSelectMusic:GetChild("Timer"):GetSeconds()
			self:sleep(1):queuecommand("GoFullMode2")
		else
			--SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;
	--Need to sleep to let the full mode animation finish, so this is in its own command.
	GoFullMode2Command=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectGroup");
	end;
	
	--Needs to sleep because without it, isSelectingDifficulty will be false while they close the difficulty select instead of after.
	TwoPartConfirmCanceledMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(-300)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	SongChosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(300);
		
		isSelectingDifficulty = true;
	end;
	
	SongUnchosenMessageCommand=function(self)
		local MusicWheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		MusicWheel:accelerate(.2);
		MusicWheel:addy(-300)
		
		self:sleep(.05);
		self:queuecommand("DifficultySelectExited");
	end;
	
	DifficultySelectExitedCommand=function(self)
		isSelectingDifficulty = false;
	end;

}

t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","JoinOverlay"))..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.145,SCREEN_CENTER_Y-90;zoom,.9;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_1))
		end;
	};
	LoadActor(THEME:GetPathG("","JoinOverlay"))..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.855,SCREEN_CENTER_Y-90;zoom,.9;visible,THEME:GetMetric("GameState", "AllowLateJoin");playcommand,"RefreshPlayer");
		PlayerJoinedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinModeChangedMessageCommand=cmd(playcommand,"RefreshPlayer");
		CoinInsertedMessageCommand=cmd(playcommand,"RefreshPlayer");
		RefreshPlayerCommand=function(self)
			self:visible(not GAMESTATE:IsHumanPlayer(PLAYER_2))
		end;
	};
};

--[[for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","CWCommandWindow"), pn)..{
		CodeMessageCommand = function(self, params)
			if params.Name == 'OpenOpList' then
				--SCREENMAN:SystemMessage("OptionsList opened")
				--SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
				MESSAGEMAN:Broadcast("CommandWindowOpened", {Player=pn})
			end
		end;
	};
end;]]
--[[t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","CWCommandWindow"), PLAYER_1)..{
		CodeMessageCommand = function(self, params)
			if params.Name == 'OpenOpList' then
				--self:sleep(1);
				--SCREENMAN:set_input_redirected(PLAYER_1,true);
				SCREENMAN:SystemMessage("OptionsList opened")
				--SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
				--ScreenSelectMusic:lockinput(9999);
				MESSAGEMAN:Broadcast("CommandWindowOpened", {Player=PLAYER_1})
			end
		end;
	};]]


t[#t+1] = LoadActor("GoFullMode")..{
	
};


return t
