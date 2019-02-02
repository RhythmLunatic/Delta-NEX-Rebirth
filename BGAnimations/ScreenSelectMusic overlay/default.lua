local isSelectingDifficulty = false;
local ScreenSelectMusic;

--Disabled because buggy
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
			--MESSAGEMAN:SystemMessage(button);
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
					if isSelectingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
					--Set a global variable so ScreenSelectGroup will jump to the group that was selected before.
					initialGroup = ScreenSelectMusic:GetChild('MusicWheel'):GetSelectedSection()
					MESSAGEMAN:Broadcast("StartSelectingGroup");
					--SCREENMAN:SystemMessage("Group select opened.");
					--No need to check if both players are present... Probably.
					SCREENMAN:set_input_redirected(PLAYER_1, true);
					SCREENMAN:set_input_redirected(PLAYER_2, true);
					musicwheel:Move(0); --Work around a StepMania bug
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

	end;
	
	CodeMessageCommand=function(self, params)
		if params.Name == "GoFullMode" then
			SCREENMAN:GetTopScreen():lockinput(1);
			--SCREENMAN:SystemMessage("Full Mode triggered!");
			GAMESTATE:ApplyGameCommand("sort,group");
			--ScreenSelectMusic:StartTransitioningScreen("SM_GoToPrevScreen");
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_SOUND"));
			SOUND:PlayOnce(THEME:GetPathS("", "FULL_VOICE"));
			MESSAGEMAN:Broadcast("GoFullMode");
			initialGroup = nil; --It can be left over from a previous session
			inBasicMode = false;
			--secondsLeft = ScreenSelectMusic:GetChild("Timer"):GetSeconds()
			self:sleep(1):queuecommand("GoFullMode2")
		else
			--SCREENMAN:SystemMessage("WTF? "..params.Name);
		end;
	end;
	--Need to sleep to let the full mode animation finish, so this is in its own command.
	GoFullMode2Command=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectMusic");
	end;
	
	LoadActor(THEME:GetPathS("","Common Cancel"))..{
        SongUnchosenMessageCommand=cmd(play);
    };
    
    LoadActor(THEME:GetPathS("","SSM_Select"))..{
        SongChosenMessageCommand=cmd(play);
        StepsChosenMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("","SSM_Confirm"))..{
        OffCommand=cmd(play);
    };

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

t[#t+1] = LoadActor("Command Window")..{
	InitCommand=cmd(draworder,100);	
};

for pn in ivalues(PlayerNumber) do
	--[[t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","CWCommandWindow"), pn)..{
		CodeMessageCommand = function(self, params)
			if params.Name == 'OpenOpList' then
				--SCREENMAN:SystemMessage("OptionsList opened")
				--SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
				--SCREENMAN:set_input_redirected(PLAYER_1,true);
				MESSAGEMAN:Broadcast("CommandWindowOpened", {Player=pn})
			end
		end;
	};]]
end;
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


t[#t+1] = LoadActor("../GoFullMode");
t[#t+1] = LoadActor("ScreenSelectGroup overlay");


return t
